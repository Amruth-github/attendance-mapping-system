import streamlit as st
from database_access import *
import pandas as pd
from st_aggrid import AgGrid
from st_aggrid.grid_options_builder import GridOptionsBuilder

def create_feilds(column):
    for i in column:
        st.text_input(f'{i[0]}', key = i[0])

def create_aggrid(table, column, type):
    df = pd.DataFrame(read(table), columns=[i[0] for i in column])
    gd = GridOptionsBuilder.from_dataframe(df)
    gd.configure_pagination(enabled=True)
    gd.configure_default_column(editable=True, groupable=True)
    gd.configure_selection(selection_mode=type, use_checkbox=True)
    gridOptions = gd.build()
    table_t = AgGrid(df, gridOptions=gridOptions)
    return table_t

def dashboard():
    with st.expander("Stats"):
        st.write(f"Total Students : {get_total_students()}")
        st.write(f"Total Teachers : {get_total_teachers()}")
        st.write(f"Average age of students : {get_avg_students()}")
        st.write(f"Average age of teachers : {get_avg_teachers()}")
        Class = st.selectbox('Select Class', [i[0] for i in get_all_class()])
        st.write(f'Total Students in {Class} : {get_number_of_students_in_class(Class)}')
    with st.expander("Query Box"):
        query = st.text_area("Enter queries")
        if st.button("Execute"):
            try:
                cursor.execute(query)
                res = process(cursor.fetchall())
                st.dataframe(pd.DataFrame(res))
                st.success("Query executed successfully")
            except mysql.connector.errors.InterfaceError:
                st.warning("No output!...Query executed successfully!")
            except Exception as e:
                st.error(e)
    with st.expander("CRUD Operations"):
        tables = get_tables()
        table = st.selectbox('Select Table', [i[0] for i in tables])
        operation = st.selectbox('Select Operation', ["Create", "Read", "Update", "Delete"])
        column = columns(table)
        match operation:
            case "Create":
                st.dataframe(pd.DataFrame(read(table), columns=[i[0] for i in column]))
                create_feilds(column)
                if st.button("Insert"):
                    vals = []
                    for i in column:
                        vals.append(st.session_state[i[0]])
                    insert(table, vals)
                    st.experimental_rerun()
            case "Read":
                if st.button("Read"):
                    st.dataframe(read(table))
            
            case "Update":
                table_t = create_aggrid(table, column, 'single')
                selected_rows = table_t['selected_rows']
                st.write("Write new values if value needs to be changed else leave it empty")
                create_feilds(column)
                if st.button("Update") or ('Executed' in st.session_state.keys()):
                    st.session_state['Executed'] = True
                    if len(selected_rows):
                        vals = []
                        """ for i in column:
                            if st.session_state[i[0]] == "":
                                vals.append((i[0], selected_rows[0][i[0]]))
                            else:
                                vals.append((i[0], st.session_state[i[0]])) """
                        for i in column:
                            if st.session_state[i[0]] != "":
                                vals.append((i[0], st.session_state[i[0]]))
                        update(table, vals, selected_rows)
                        st.success("Updated!")
                        del st.session_state['Executed']
                        st.experimental_rerun()
                    else:
                        st.warning('Select atleast one row')

            case "Delete":
                table_t = create_aggrid(table, column, 'multiple')
                selected_rows = table_t['selected_rows']
                if st.button("Delete"):
                    if len(selected_rows):
                        delete(table, selected_rows)
                        st.experimental_rerun()
                    else:
                        st.warning('Select atleast one row')
