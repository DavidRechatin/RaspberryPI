<?php
$dir = "/home/pi/media";
$phpFile = "index.php";

if (isset($_GET['media'])) {
                $file = $_GET['media'];
                shell_exec("killall omxplayer");
                shell_exec("killall omxplayer.bin");
                shell_exec("rm /tmp/cmd -f");
                shell_exec("mkfifo /tmp/cmd");
                pclose(popen('omxplayer -o hdmi "'.$dir.'/'.$file.'" </tmp/cmd &','r'));
                sleep(1);
                shell_exec("echo -n . > /tmp/cmd");
                }
if (isset($_GET['command'])) {
                $command = $_GET['command'];
                switch ($command) {
                        case "pause":
                                shell_exec("echo -n p > /tmp/cmd");
                                break;
                        case "stop":
                                shell_exec("echo -n q > /tmp/cmd");
                                break;
                        case "another":
                                echo "i equals 2";
                                break;
                        }
}
if (isset($_GET['image'])) {
    echo "image<br>";
    system("sh test.sh",$error);

    echo "<pre>$error</pre>";


}
?>

<html>
<head>
<title>Lecteur Raspberry Pi</title>
</head>
<body>
<?php
if ($handle = opendir($dir)) {
    while (false !== ($entry = readdir($handle))) {
        if ($entry != "." && $entry != ".." && $entry != "omxplayer.log" && $entry != "omxplayer.old.log") {
            echo "$entry >> \n";
            echo "<a href=\"$phpFile?media=$entry\">Play</a>\n";
            echo "<br>\n";

        }
    }
    closedir($handle);
}

echo "<pre>";
echo "<a href=$phpFile>Home</a> - "; 
echo "<a href=$phpFile?command=stop>Stop</a> - ";
echo "<a href=$phpFile?command=pause>Pause</a>";
echo "</pre>";

/*
sudo chmod a+rw /dev/vchiq

*/
?>
</body>
</html>