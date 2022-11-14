import streamlit as st
from database_access import *
from student import student
from teacher import teacher
from dashboard import dashboard

authentication_status = False

def render_page(username, state):
    match state:
        case "Student":
            student(username)
        case "Teacher":
            teacher(username)
        case "Admin":
            dashboard()
            
def set_null():
    for i in st.session_state:
        del st.session_state[i]

def main():
    st.title("Attendance Mapping System")
    choice = st.sidebar.selectbox("Menu", ["Home", "Login"])
    match choice:
        case "Home":
            st.subheader("View and Manage your attendance records")
            st.image("./attendance.jpg", width = 200)
        case "Login":
            username = st.sidebar.text_input("Username")
            password = st.sidebar.text_input("Password", type = "password")
            state = st.sidebar.radio("Login As", ["Student", "Teacher", "Admin"], key = "state")
            if (('Logged In' in st.session_state.keys()) and (state == st.session_state['prev_state'])):
                if st.sidebar.button("Logout"):
                    set_null()
                    st.experimental_rerun()
                render_page(username, state)
            else:
                if st.sidebar.button("Login"):
                    if authenticate_login(username, password, state):
                        st.session_state["Logged In"] = True
                        st.session_state["prev_state"] = state
                        render_page(username, state)
                    else:
                        st.error("Incorrect Username or Password Combination")
            
            
if __name__ == '__main__':
    main()
                
    