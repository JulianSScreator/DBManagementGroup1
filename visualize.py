import csv
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from Julian_database_config import load_config
import psycopg2

def write_results_to_csv():
    config = load_config()
    query = """
    SELECT 
        mi.movie_title, 
        mi.worldwide_box_office,
        mi.international_box_office,
        mi.domestic_box_office,
        COUNT(er.id) AS total_expert_reviews, 
        AVG(CASE 
                WHEN er.individual_score ~ '^[0-9.]+$' THEN CAST(er.individual_score AS numeric) 
                ELSE NULL 
            END) AS avg_expert_score,
        AVG(CASE 
                WHEN er.positive_emotion ~ '^[0-9.]+$' THEN CAST(er.positive_emotion AS numeric) 
                ELSE NULL 
            END) AS avg_positive_emotion 
    FROM 
        movie_info mi
    JOIN 
        expert_reviews er ON mi.id = er.movie_id
    GROUP BY 
        mi.id
    ORDER BY 
        total_expert_reviews DESC;
    """

    try:
        with psycopg2.connect(**config) as conn:
            with conn.cursor() as cur:
                # Execute the SQL query
                cur.execute(query)
                rows = cur.fetchall()

                # Write the results to a CSV file
                with open('results1.csv', 'w', newline='') as file:
                    writer = csv.writer(file)
                    # Write the correct header based on the query columns
                    writer.writerow(['Movie Title', 'Worldwide Box Office', 'International Box Office', 
                                     'Domestic Box Office', 'Total Expert Reviews', 'Avg Expert Score', 'Avg Positive Emotion'])
                    # Write each row to the CSV
                    for row in rows:
                        writer.writerow(row)

    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Error: {error}")

# Visualize the data using seaborn
def visualize_data():
    # Load the data from the CSV file into a DataFrame
    df = pd.read_csv('results1.csv')

    # Convert the box office columns to numeric, removing any non-numeric characters
    df['Worldwide Box Office'] = pd.to_numeric(df['Worldwide Box Office'], errors='coerce')
    df['International Box Office'] = pd.to_numeric(df['International Box Office'], errors='coerce')
    df['Domestic Box Office'] = pd.to_numeric(df['Domestic Box Office'], errors='coerce')

    # Create a scatter plot with a regression line
    sns.regplot(x='Avg Expert Score', y='Worldwide Box Office', data=df, scatter_kws={"s": 50}, line_kws={"color": "red"})
    
    # Add labels and title
    plt.title('Average Expert Score vs Worldwide Box Office (with Regression Line)')
    plt.xlabel('Average Expert Score')
    plt.ylabel('Worldwide Box Office')

    # Show the plot
    plt.show()

# Run the script
if __name__ == '__main__':
    write_results_to_csv()  # Execute the function to fetch data and write to CSV
    visualize_data()        # Visualize the data using Seaborn with regression line
