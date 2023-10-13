const express = require('express');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const mysql = require('mysql');

const app = express();
const port = 3000;

app.use(bodyParser.json());


// Create MySQL connection
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '123',
  database: 'EF',
});



connection.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  
  console.log('Connected to MySQL database');
  
  // Reset isLiked to 0 for all questions
});
app.post('/reset-likes', (req, res) => {
  const resetQuery = 'UPDATE questions SET isLiked = 0';

  connection.query(resetQuery, (error) => {
    if (error) {
      console.error('Error resetting isLiked:', error);
      res.status(500).json({ error: 'Internal server error' });
    } else {
      console.log('isLiked reset successful');
      res.status(200).json({ message: 'isLiked reset successful' });
    }
  });
});




app.post('/login', (req, res) => {
  const { username, password } = req.body;
  const query = 'SELECT * FROM users WHERE username = ? AND password = ?';
  connection.query(query, [username, password], (error, results) => {
    if (error) {
      console.error('Error executing MySQL query:', error);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }
    if (results.length > 0) {
      const user = {
        username: results[0].username,
        firstName: results[0].firstName, // Assuming 'firstName' is a column in the 'users' table
        lastName: results[0].lastName // Assuming 'lastName' is a column in the 'users' table
      };
      const token = jwt.sign(user, 'your-jwt-secret', { expiresIn: '1h' });
      res.json({ token: token, firstName: user.firstName, lastName: user.lastName });
    } else {
      res.status(401).json({ error: 'Invalid credentials' });
    }
  });
});

app.post('/register', (req, res) => {
  const { firstname, lastname, username, password } = req.body;
  console.log(req.body)

  const query = 'INSERT INTO users (firstname, lastname, username, password) VALUES (?, ?, ?, ?)';
  connection.query(query, [firstname, lastname, username, password], (error, results) => {
    if (error) {
      console.error('Error executing MySQL query:', error);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }

    // Registration successful
    res.json({ success: true });
  });
});
// app.post('/questions', (req, res) => {
//   const { question, index, firstName, lastName, question_like, question_view } = req.body;
//   console.log(req.body);

//   const query = 'INSERT INTO questions (question,index_number,firstName,lastName,question_like,question_view) VALUES (?,?,?,?,?,?)';
//   connection.query(query, [question, index, firstName, lastName, question_like, question_view], (error, results) => {
//     if (error) {
//       console.error('Error executing MySQL query:', error);
//       res.status(500).json({ error: 'Internal server error' });
//       return;
//     }

//     // Question inserted successfully
//     res.json({ message: 'Question added' });
//   });
// });

app.post('/questions', (req, res) => {
  const { question, index, firstName, lastName } = req.body;
  console.log(req.body);

  const question_like = 0;  // Set question_like to 0
  const question_view = 0;  // Set question_view to 0
  const isLiked = false;    // Assuming isLiked is a boolean field

  const query = 'INSERT INTO questions (question, index_number, firstName, lastName, question_like, question_view, isLiked) VALUES (?, ?, ?, ?, ?, ?, ?)';
  connection.query(query, [question, index, firstName, lastName, question_like, question_view, isLiked], (error, results) => {
    if (error) {
      console.error('Error executing MySQL query:', error);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }
    // Question inserted successfully
    res.json({ message: 'Question added' });
  });
});



app.post('/questions/:index_number/like', (req, res) => {
  const questionIndexNumber = req.params.index_number;

  // Fetch the current like status of the question from the database
  const fetchQuery = 'SELECT question_like, isLiked FROM questions WHERE index_number = ?';
  connection.query(fetchQuery, [questionIndexNumber], (fetchError, fetchResults) => {
    if (fetchError) {
      console.error('Error executing MySQL query:', fetchError);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }

    if (fetchResults.length === 0) {
      res.status(404).json({ error: 'Question not found' });
      return;
    }

    const question = fetchResults[0];
    const currentLikeValue = question.question_like;
    const isLiked = Boolean(question.isLiked); // Convert to boolean

    let updatedLikeValue;
    let updatedIsLiked;

    if (isLiked) {
      updatedLikeValue = currentLikeValue - 1;
      updatedIsLiked = 0; // Set isLiked to 0 (false)
    } else {
      updatedLikeValue = currentLikeValue + 1;
      updatedIsLiked = 1; // Set isLiked to 1 (true)
    }

    // Update the 'question_like' and 'isLiked' values in the database
    const updateQuery = 'UPDATE questions SET question_like = ?, isLiked = ? WHERE index_number = ?';
    connection.query(updateQuery, [updatedLikeValue, updatedIsLiked, questionIndexNumber], (updateError, updateResults) => {
      if (updateError) {
        console.error('Error executing MySQL query:', updateError);
        res.status(500).json({ error: 'Internal server error' });
        return;
      }

      // Fetch the updated question from the database
      const fetchUpdatedQuery = 'SELECT * FROM questions WHERE index_number = ?';
      connection.query(fetchUpdatedQuery, [questionIndexNumber], (fetchUpdatedError, fetchUpdatedResults) => {
        if (fetchUpdatedError) {
          console.error('Error executing MySQL query:', fetchUpdatedError);
          res.status(500).json({ error: 'Internal server error' });
          return;
        }

        const updatedQuestion = fetchUpdatedResults[0];
        const resetQuery = 'INSERT questions SET isLiked = 0';
        connection.query(resetQuery, (error, results) => {
          if (error) {
            console.error('Error resetting isLiked:', error);
            return;
          }
          console.log('Reset isLiked to 0 for all questions');
        });
      
        // Send the updated question as the response
        res.json(updatedQuestion);
      });
    });
  });
 

});


app.get('/questions', (req, res) => {
  
  const query = 'SELECT * FROM questions';

  connection.query(query, (error, results) => {
    if (error) {
      console.error('Error executing MySQL query:', error);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }
    res.json(results);
  });
});

// Assuming you have already set up your database connection and Express server

// Route to fetch question_like count by index_number
// Assuming you have already established a database connection and set up your Express server

// Route to fetch question_like count by index_number
// Assuming you have already established a database connection and set up your Express server

// Route to fetch question_like count by index_number
app.get('/questions/:indexNumber/likeCount', (req, res) => {
  const indexNumber = req.params.indexNumber;

  // Execute the SQL query to fetch the question_like count
  const query = `SELECT question_like FROM questions WHERE index_number = ${indexNumber}`;

  // Execute the query using your database connection
  connection.query(query, (err, result) => {
    if (err) {
      console.error('Error executing SQL query:', err);
      res.status(500).json({ error: 'Failed to fetch question_like count' });
    } else {
      if (result.length > 0) {
        const questionLikeCount = result[0].question_like;

        // Create a response object with the question_like count
        const response = {
          likeCount: questionLikeCount
        };

        res.json(response);
      } else {
        // If question is not found, return zero as the default value
        const defaultLikeCount = 0;
        const response = {
          likeCount: defaultLikeCount
        };

        res.json(response);
      }
    }
  });
});










app.get('/sustain', (req, res) => {
  const query = 'SELECT p_name, p_cat, p_mat, p_price, p_decomp_time, p_pic FROM Sustain';

  // Execute the query
  connection.query(query, (err, rows) => {
    if (err) {
      console.error('Error executing the query: ', err);
      res.status(500).json({ error: 'Failed to fetch data from the database' });
      return;
    }

    // Send the retrieved data as a response
    res.json(rows);
  });
});

app.post('/comments', (req, res) => {
  const { comment, index, firstName, lastName } = req.body;
  console.log(req.body);

  // Insert the comment, index, firstName, and lastName into the MySQL database
  const query = 'INSERT INTO textcomments (comments, index_number, firstname, lastname) VALUES (?, ?, ?, ?)';
  connection.query(query, [comment, index, firstName, lastName], (err, result) => {
    if (err) {
      console.error('Error inserting comment:', err);
      res.status(500).send('Error inserting comment');
      return;
    }
    console.log('Comment inserted:', result);
    res.status(200).send('Comment inserted successfully');
  });
});

// Assuming you have the necessary dependencies and database connection already set up
app.get('/comments/:indexNumber', (req, res) => {
  const indexNumber = req.params.indexNumber;

  // Perform a database query to retrieve the comments based on the indexNumber
  connection.query(
    'SELECT * FROM textcomments WHERE index_number = ?',
    [indexNumber],
    (error, results) => {
      if (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred' });
      } else {
        res.json(results);
      }
    }
  );
});





app.post('/logout', (req, res) => {
  const resetQuery = 'UPDATE questions SET isLiked = 0';

  connection.query(resetQuery, (error) => {
    if (error) {
      console.error('Error resetting isLiked:', error);
      res.status(500).json({ error: 'Internal server error' });
    } else {
      console.log('isLiked reset successful  ');

      // Perform any necessary logout logic, such as clearing the session or token
      // ...
      res.status(200).json({ message: 'Logout successful' });
    }
  });
});



app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
