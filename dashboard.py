import pandas as pd 
import matplotlib.pyplot as plt 
import streamlit as st 

#load EV data
df=pd.read_csv("ev_data.csv")

st.title("⚡ EV Analytics Dashboard")

#show raw data
st.subheader("Raw EV Data")
st.write(df.head())

#SOC vs Time
st.subheader("SOC vs Time")
fig1,ax1=plt.subplots()
ax1.plot(df['time'],df['soc'],label="SOC(%),color='green")
ax1.set_xlabel("Time(s)")
ax1.set_ylabel("SOC(%)")
st.pyplot(fig1)

# Efficiency (Speed per Current)
st.subheader("Efficiency(speed/current)")
df['efficiency']=df['speed']/(df['current']+ 1e-3)
fig2,ax2=plt.subplots()
ax2.plot(df['time'],df['efficiency'],label="Efficiency",color='Blue')
ax2.set_xlabel("Time (s)")
ax2.set_ylabel("Efficiency (RPM/A)")
st.pyplot(fig2)

# Estimated Remaining Range (very simple model)
battery_capacity_kWh = 40   # example battery size
energy_used = (df['voltage'] * df['current']).cumsum() / 3600000  # kWh
remaining_energy = battery_capacity_kWh - energy_used
range_est_km = remaining_energy.iloc[-1] * 5   # assume 5 km per kWh

st.subheader("Estimated Remaining Range (km)")
st.write(f"{range_est_km:.2f} km")





