<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/lowtancq/public_html/s269957/PHPMailer-master/src/Exception.php';
require '/home8/lowtancq/public_html/s269957/PHPMailer-master/src/PHPMailer.php';
require '/home8/lowtancq/public_html/s269957/PHPMailer-master/src/SMTP.php';

//Instantiation and passing `true` enables exceptions
$mail = new PHPMailer(true);
echo "Trying to send email";
try {
    //Server settings
    $mail->SMTPDebug = 0;                      //Enable verbose debug output
    $mail->isSMTP();                                            //Send using SMTP
    $mail->Host       = 'mail.lowtancqx.com';                     //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
    $mail->Username   = 'nailsalon@lowtancqx.com';                     //SMTP username
    $mail->Password   = '~Russl7zLndb';                               //SMTP password
    $mail->SMTPSecure = 'tls';         //Enable TLS encryption; `PHPMailer::ENCRYPTION_SMTPS` encouraged
    $mail->Port       = 587;                                    //TCP port to connect to, use 465 for `PHPMailer::ENCRYPTION_SMTPS` above

    //Recipients
    $mail->setFrom('nailsalon@lowtancqx.com', 'Mailer');
    $mail->addAddress('xiiaoxiinlow@gmail.com', 'LXX');     //Add a recipient
    
    
    //Content
    $mail->isHTML(true);                                  //Set email format to HTML
    $mail->Subject = 'Here is the subject';
    $mail->Body    = 'This is the HTML message body <b>in bold!</b>';
    $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';

    $mail->send();
    echo 'Message has been sent';
} catch (Exception $e) {
    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
}
?>