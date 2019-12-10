<?php
include 'conn.php';
$ts1 = $_GET['TS1'];
$ts2 = $_GET['TS2'];
$ts3 = $_GET['TS3'];
$ts4 = $_GET['TS4'];
$ts5 = $_GET['TS5'];
$ts6 = $_GET['TS6'];
$ts7 = $_GET['TS7'];
$ts8 = $_GET['TS8'];
$gap1 = $_GET['GAP1'];
$gap2 = $_GET['GAP2'];
$d1 = $_GET['D1'];
$d2 = $_GET['D2'];
$d3 = $_GET['D3'];
$d4 = $_GET['D4'];
$d5 = $_GET['D5'];
$d6 = $_GET['D6'];
$bd1 = $_GET['BD1'];
$bd2 = $_GET['BD2'];

$sql = "INSERT INTO sumtransactions (t1, t2, t3, t4, t5, t6, t7, t8, blockgap, actgap, d1, d2, d3, d4, d5, d6, bd1, bd2) VALUES ($ts1, $ts2, $ts3, $ts4, $ts5, $ts6, $ts7, $ts8, $gap1, $gap2, $d1, $d2, $d3, $d4, $d5, $d6, $bd1, $bd2)";
if ($connect->query($sql) === TRUE) {
$response['result'] = "success";
     echo json_encode($response);
     }else {
       echo "Error:".$sql."<br/>".$connect->error;
     }
mysqli_close($connect);
?>
