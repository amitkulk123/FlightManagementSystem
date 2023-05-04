# Instructions to setup and run the app

Inside the zip folder, there should be three separate folders: frontend, backend, database. 

To setup the app, we need to perform the following steps:

1) Run the Database
- The first step is to initialize the database. Switch to the database repo and run the `STARTING_POINT_v2.sql` and then the `stored_procedures_team15.sql` file.

2) Run the Backend
- Now we need to start the backend. To do this, in terminal, `cd` to the backend repo and run `npm install`. This should install all the packages that are necessary for the backend to run. If you don't have `npm`, then install that first.
- Now, you may notice that in the `index.js` file, the password is declared as `process.env.DB_PASSWORD`. It's bad practice to put your password as plain text so to fix this, you need to enter this command in terminal: `export DB_PASSWORD='yourpassword'` where `'yourpassword'` is the password that you used to setup MySQL. 
- Once you get all the packages installed, do `node index.js` or alternatively `npm start`. This will start a backend server on `localhost:3001` where all the SQL queries are now converted into a JSON file that can be read on the web through an API.
  - To see this in action, in your browser, go to `http://localhost:3001/api/{table}` where `{table}` is the table you want to see. 
  - For example, for the airport table, you would do `http://localhost:3001/api/airport` and it'll look like this:
  <img width="607" alt="Screenshot 2023-04-24 at 6 23 33 PM" src="https://github.gatech.edu/storage/user/46053/files/637c5a30-5e1f-4745-aba1-39159b1c55fd">
  - You can also use postman to make a `GET` request to the same URL like so:
  <img width="1257" alt="Screenshot 2023-05-03 at 1 00 03 PM" src="https://github.gatech.edu/storage/user/46053/files/3861f3b0-2346-48a1-8bd6-b8e31bbc3019"> 

3) Run the Frontend
- Just like with the backend, `cd` to the frontend repo and do `npm install` to install all the necessary packages. 
- Now do `npm start` to start the web app and it should automatically open in your browser as a localhost.
- If it's done correctly, it should look like this:

  ![ezgif-5-393abffa21](https://github.gatech.edu/storage/user/46053/files/c45b5c40-e337-4793-8baa-471f5b114365)

### Debugging
- Remember that you need to run both the frontend and backend at the same time for this to work! So first start the backend, open another terminal tab and then start the frontend. 
- Also if you're getting errors with packaging missing, just install that package with `npm`. So if it says in the frontend that `axios` is missing, just run `npm install axios`

# Technologies Used
To build our web app, we used the commonly-known MERN stack but instead of MongoDB, we used mySQL. 

Here's a diagram showing how our app works on a high-level:
![react-node-express-mysql-crud-example-architecture](https://github.gatech.edu/storage/user/46053/files/adadf5c7-1116-4a2e-ae57-6ffb16fffe85)

For the frontend, we utilized React to build the frontend with all the components and navigation. We used `react-table` to add sorting ability to the table and `react-collapsible` to collapse stored procedures to keep the interface clean. To communicate with the backend, we used `axios` which sends the data that the user inputs to the backend API.

The backend was built with Node.js and Express which are commonly used to build APIs for the web. We wrote a series of `GET ` and `POST` requests that are used to communicate with the database. `GET` is used to retrieve the tables which is used for all the entities and views (19-24). `POST` is used to call the stored procedures which makes a change to the database by passing in parameters. To connect to the mySQL database, we used a library called `mysql2` which enables the database connection and querying.

The mySQL database is the same as the one that we used for phase 3 with a few changes to account for edge cases that we missed.

# Explanation of how work was distributed among the team members
Amal:
- Created the views for each of the tables in the frontend
- Wrote POST requests for each of the stored procedures
  
Amit:
- Connected the frontend, backend, and database together. 
- Verified the data type in the API requests matched the ones in the database (null, boolean, integer, string)
  
Anisha:
- Manually tested the scripts in sql and the database
- Added styling 
  
Justin:
- Tested sql and database scripts
- Revised formatting
- Proofread code, debugging
  



