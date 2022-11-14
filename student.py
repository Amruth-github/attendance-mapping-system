import streamlit as st
from database_access import *
import pandas as pd
from time import sleep
import datetime

def student(username):
    data = get_student_details(username)
    st.write(f"""
        <p style = "padding-left:17cm;width:150cm;">{data[0][1]}</p>
        <p style = "width:150cm;padding-left:17cm;">{data[0][0]}</p>
        <p style = "padding-left:17cm;">{data[0][-1]}</p>
    """, unsafe_allow_html = True)
    with st.expander("Day Wise"):
        doa = st.date_input("Enter Date", key =  "date", max_value=datetime.date.today())
        if st.button("Get Details"):
            data = course_of_student(username, doa)
            df_d = []
            if len(data):
                for i in data[0]:
                    status = get_attendance_status(username, i, doa)
                    if len(status):
                        df_d.append((i, status[0][0]))
                    else:
                        df_d.append((i, "A"))
                st.dataframe(pd.DataFrame(df_d, columns=["Course Code", "Status"]))

            else:
                st.warning("Holiday!")