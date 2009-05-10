<?php
if (isset($_REQUEST['mockfbmltext'])) {
  echo $_REQUEST['mockfbmltext'];
  exit;
}

require_once 'dbappinclude.php';

echo "<p>hello $user</p>";

$rs = query("select count from counter");
if ($row = mysql_fetch_assoc($rs)) {
  $count = $row['count'];
  query("update counter set count=count+1");
} else {
  query("insert into counter values (1)");
  $count = 1;
}

echo "<p>the count is $count</p>";

if (isset($_REQUEST['profiletext'])) {
  $facebook->api_client->profile_setFBML($_REQUEST['profiletext'], $user);
  $facebook->redirect($facebook->get_facebook_url() . '/profile.php');
}

echo '<form action="" method="get">';
echo '<input name="profiletext" type="text" size="30" value=""><br>';
echo '<input name="submit" type="submit" value="Display text on profile">';
echo '</form>';

$fbml = <<<EndHereDoc
<form>
<input name="mockfbmltext" type="text" size="30">
<br />
<input type="submit"
  clickrewriteurl="$appcallbackurl"
  clickrewriteid="preview" value="Draw text below"
/>
<br />
<div id="preview" style="border-style: solid; border-color: black;
  border-width: 1px; padding: 5px;">
</div>
</form>
EndHereDoc;

$facebook->api_client->profile_setFBML($fbml, $user);

echo "<p>the following form was added to the profile box:</p>";

echo $fbml;
