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
        id: results[0].id,
        username: results[0].username,
        firstName: results[0].firstName, // Assuming 'firstName' is a column in the 'users' table
        lastName: results[0].lastName // Assuming 'lastName' is a column in the 'users' table
      };
      const token = jwt.sign(user, 'your-jwt-secret', { expiresIn: '30d' });
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

app.post('/questions', (req, res) => {
  const { question, index, firstName, lastName } = req.body;
  console.log(req.body);
  const question_view = 0;  // Set question_view to 0

  const query = 'INSERT INTO questions (question, index_number, firstName, lastName, question_view) VALUES (?, ?, ?, ?, ?)';
  connection.query(query, [question, index, firstName, lastName,  question_view], (error, results) => {
    if (error) {
      console.error('Error executing MySQL query:', error);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }
    // Question inserted successfully
    res.json({ message: 'Question added' });
  });
});

app.post('/questions/:index_number/like/:token', (req, res) => {
  const {token} = req.params
  //question id from question table 
  const questionIndexNumber = req.params.index_number;
  const questionId = parseInt(questionIndexNumber)
  const {isLiked} = req.body

  //extract the value of id from JWT
  const {id} = jwt.decode(token)
  // check null value check type 
  let stmt = isLiked === 1 ? `insert into user_likes values (?,?)` : `delete from user_likes where user_id=? and question_id=?`
  
  connection.query(stmt, [id,questionId], (fetchError, fetchResults) => {
    console.log(fetchResults)
    if (fetchError) {
      console.error('Error executing MySQL query:', fetchError);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }
    
    // will focus on select on the number of row 
    

    const query2 = `SELECT index_number,question,firstName,lastName,question_view,
  (SELECT count(*) FROM user_likes where user_likes.question_id = questions.index_number) as question_like,

   (SELECT count(*) FROM user_likes where user_likes.question_id = questions.index_number AND user_id = ?) as isLiked

   FROM questions where index_number = ?`

  connection.query(query2,[id,questionId], (error, results) => {
    if (error) {
      console.error('Error executing MySQL query:', error);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }
    res.json(results[0]);
  });
  })
});

// Handle the request to increment the question_view count
app.put('/questions/:index/view', (req, res) => {
  try {
    const questionIndex = req.params.index;

    // Construct the SQL query with a parameter
    const query = 'UPDATE questions SET question_view = question_view + 1 WHERE index_number = ?';

    // Execute the query with the parameter value
    connection.query(query, [questionIndex], (error, result) => {
      if (error) {
        console.error('Error incrementing question view count:', error);
        return res.status(500).json({ error: 'Internal server error' });
      }

      if (result.affectedRows === 0) {
        return res.status(404).json({ error: 'Question not found' });
      }

      return res.status(200).json({ message: 'Question view count incremented successfully' });
    });
  } catch (error) {
    console.error('Error incrementing question view count:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/questions/:token?', (req, res) => {
  const token = req.params.token;
  // Check if a token is provided
  if (token) {
    const { id } = jwt.decode(token);
    const query = `SELECT index_number, question, firstName, lastName, question_view,
      (SELECT COUNT(*) FROM user_likes WHERE user_likes.question_id = questions.index_number) AS question_like,
      (SELECT COUNT(*) FROM user_likes WHERE user_likes.question_id = questions.index_number AND user_id = ?) AS isLiked
      FROM questions ORDER BY question_like DESC`;

    connection.query(query, [id], (error, results) => {
      if (error) {
        console.error('Error executing MySQL query:', error);
        res.status(500).json({ error: 'Internal server error' });
        return;
      }
      res.json(results);
    });
  } else {
    const query = `SELECT index_number, question, firstName, lastName, question_view,
      (SELECT COUNT(*) FROM user_likes WHERE user_likes.question_id = questions.index_number) AS question_like,
      0 AS isLiked
      FROM questions ORDER BY question_like DESC`;

    connection.query(query, (error, results) => {
      if (error) {
        console.error('Error executing MySQL query:', error);
        res.status(500).json({ error: 'Internal server error' });
        return;
      }
      res.json(results);
    });
  }
});

app.get('/questions', (req, res) => {
  const {token} = req.params
  const {id} = jwt.decode(token);
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

app.get('/sustain', (req, res) => {
  const query = 'SELECT p_name, p_cat, p_mat, p_price, p_decomp_time, p_pic,p_detail,p_ref FROM Sustain';

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

app.get('/comment-count/:indexNumber', (req, res) => {
  const indexNumber = req.params.indexNumber;
  const query = 'SELECT COUNT(*) AS count FROM textcomments WHERE index_number = ?';

  connection.query(query, [indexNumber], (error, results) => {
    if (error) {
      console.error('Error executing MySQL query:', error);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }
    
    res.json(results[0]);
  });
});



app.post('/logout', (req, res) => {
  res.json({ message: 'Logout successful' });
});


app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
