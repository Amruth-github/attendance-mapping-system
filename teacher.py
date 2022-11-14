from database_access import *
import streamlit as st
import pandas as pd
from st_aggrid import AgGrid
from st_aggrid.grid_options_builder import GridOptionsBuilder
import datetime

def teacher(username):
    data = get_teacher_details(username)
    st.write(f"""
        <p style = "padding-left:17cm;width:150cm;">{data[0][0]}</p>
        <p style = "width:150cm;padding-left:17cm;">{data[0][1]}</p>""", unsafe_allow_html=True)
    date = st.date_input('Select Date', max_value=datetime.date.today())
    course = st.selectbox('Select Course', [i[0] for i in get_teacher_courses(username)])
    Class = st.selectbox('Select Class', [i[0] for i in get_class_on_day(username, date, course)])
    df = pd.DataFrame(get_students_of_class(Class), columns=["SRN", "Name"])
    if st.button("Get Students") or ('clicked' in st.session_state.keys()):
        st.session_state['clicked'] = True
        gd = GridOptionsBuilder.from_dataframe(df)
        gd.configure_pagination(enabled=True)
        gd.configure_default_column(editable=True, groupable=True)
        gd.configure_selection(selection_mode='multiple', use_checkbox=True)
        gridOptions = gd.build()
        table = AgGrid(df, gridOptions=gridOptions)
        selected_rows = table['selected_rows']
        if st.button('Update Attendance'):
            update_attendance(selected_rows, course, date)
            st.success("Attendance Updated Successfully")
