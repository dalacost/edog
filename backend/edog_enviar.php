<?php
/*
* Básicamente lo que hace este script es enviar el periodico a los destinatarios
* que se indiquen. 
*
*parámetros: 
*
* Archivo: el archivo del periodico que se desea enviar. 
*
*
*/

date_default_timezone_set('America/Santiago');
require_once('incudes/PHPMailer/class.phpmailer.php'); 

parse_str(implode('&', array_slice($argv, 1)), $_GET);
$archivo = $_GET['archivo'];



 
$mail = new PHPMailer(true); 
$mail->IsSMTP(); 
 
try {
	//------------------------------------------------------
  	  $correo_emisor="edog@gulix.cl";
	  $nombre_emisor="EDog";
	  $contrasena="caninovirtual.";
	  $correo_destino_default="edog@gulix.cl";
	  $nombre_destino_default="EDog";
	  $correo_reply_to="contacto@gulix.cl";
	  $nombre_remply_to="Gulix";
	//--------------------------------------------------------
	  $mail->SMTPDebug  = 2;
	  $mail->SMTPAuth   = true;
	  $mail->SMTPSecure = "ssl";
	  $mail->Host       = "smtp.gmail.com";
	  $mail->Port       = 465;
	  $mail->Username   = $correo_emisor;
	  $mail->Password   = $contrasena;
	  $mail->SetFrom($correo_emisor, $nombre_emisor);
	  $mail->AddReplyTo($correo_reply_to, $nombre_remply_to);
	  $mail->AddAddress($correo_destino_default, $nombre_destino_default);
	  
  $mail->AddBCC('racl@gulix.cl', '');
  $mail->AddBCC('danilote@gulix.cl', '');
  $mail->AddBCC('fedoro@gulix.cl', '');
  $mail->AddBCC('jvidal@gulix.cl', '');
  
  
  //Asunto del correo
  $mail->Subject = 'Periodico del dia';
  //Mensaje alternativo en caso que el destinatario no pueda abrir correos HTML
  $mail->Body = 'Adjunto el periodico de hoy. Guau!.';
  //El cuerpo del mensaje, puede ser con etiquetas HTML
  //Archivos adjuntos
 $mail->AddAttachment($archivo); // attachment

//  $mail->AddAttachment('img/logo.jpg');      // Archivos Adjuntos
  //Enviamos el correo
  $mail->Send();
  echo "Mensaje enviado. Guau!";
} catch (phpmailerException $e) {
  echo $e->errorMessage(); //Errores de PhpMailer
} catch (Exception $e) {
  echo $e->getMessage(); //Errores de cualquier otra cosa.
}
?>
