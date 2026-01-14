# Import Libraries
import pandas as pd
import numpy as np
from sqlalchemy import create_engine

from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans

import matplotlib.pyplot as plt

# Connect to the Data Warehouse and Load Data
engine = create_engine("postgresql://postgres:password@localhost:5432/airport_dw")

# Load shop sales summary (aggregate per shop)
query = 'SELECT * FROM shop_sales_summary'
df = pd.read_sql(query, engine)

print("Sample data:")
print(df.head())

# Prepare Data for Clustering
# Drop identifiers
df_model = df.drop(columns=["shop_sk"])

# Normalize Numerical Features
scaler = StandardScaler()
X_scaled = scaler.fit_transform(df_model)

# Elbow Method to Determine Optimal K
inertia = []
k_range = range(1, 11)

for k in k_range:
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(X_scaled)
    inertia.append(kmeans.inertia_)

# Plot the elbow curve
plt.figure(figsize=(8,6))
plt.plot(k_range, inertia, marker='o')
plt.xlabel("Number of clusters (K)")
plt.ylabel("Inertia")
plt.title("Elbow Method for Optimal Number of Clusters")
plt.show()

optimal_k = 2

# Apply K-Means with Optimal K
kmeans = KMeans(n_clusters=optimal_k, random_state=42)
clusters = kmeans.fit_predict(X_scaled)

# Add cluster labels to the original dataframe
df["cluster"] = clusters

# Analyze Clusters
cluster_summary = df.groupby("cluster").mean(numeric_only=True)
print("\nCluster summary:")
print(cluster_summary)

# Optional: Simple Visualization
plt.figure(figsize=(8,6))
plt.scatter(
    df["total_sales"],
    df["num_sales"],
    c=df["cluster"],
    cmap="viridis"
)
plt.xlabel("Total Sales")
plt.ylabel("Number of Sales")
plt.title("Shop Clustering Based on Sales Profile")
plt.show()
