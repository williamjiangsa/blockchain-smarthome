<?php
include 'conn.php';
$ts1 = $_GET['TS1'];
$ts2 = $_GET['TS2'];
$ts3 = $_GET['TS3'];

$sql = "INSERT INTO transactions (ts1, ts2, ts3) VALUES ($ts1, $ts2, $ts3)";
if ($connect->query($sql) === TRUE) {
$response['result'] = "success";
     echo json_encode($response);
     }else {
       echo "Error:".$sql."<br/>".$connect->error;
     }
mysqli_close($connect);
?>
