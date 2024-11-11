<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$conn = new mysqli('localhost', 'root', '', 'adminduk_db');

if ($conn->connect_error) {
    die(json_encode(['error' => 'Connection failed']));
}

$action = $_POST['action'] ?? '';

switch($action) {
    case 'login':
        $email = $conn->real_escape_string($_POST['email']);
        $password = $conn->real_escape_string($_POST['password']);
        
        $result = $conn->query("SELECT * FROM users WHERE email='$email' AND password='$password'");
        if($result->num_rows > 0) {
            echo json_encode(['user' => $result->fetch_assoc()]);
        } else {
            echo json_encode(['error' => 'Invalid credentials']);
        }
        break;
        
    case 'register':
        $email = $conn->real_escape_string($_POST['email']);
        $password = $conn->real_escape_string($_POST['password']);
        $name = $conn->real_escape_string($_POST['name']);
        
        $result = $conn->query("INSERT INTO users (email, password, name) VALUES ('$email', '$password', '$name')");
        if($result) {
            echo json_encode(['message' => 'Registration successful']);
        } else {
            echo json_encode(['error' => 'Registration failed']);
        }
        break;
}

$conn->close();
?> 