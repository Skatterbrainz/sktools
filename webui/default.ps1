if ($SkUseDashboard -eq "TRUE") {
	$mainPage = "dashboard.ps1"
}
else {
	$mainPage = "main.ps1"
}
$mainPage = "main.ps1"
@"
<!DOCTYPE html>
<html>
<head>
	<title>$Global:SkAppName</title>
	<meta charset="UTF-8">
	<meta name="description" content="SkatterTools. http://github.com/skatterbrainz">
	<meta name="author" content="Skatterbrainz">
	<!-- if you are reading this it means you are nerdy AF! -->
</head>
<frameset rows="120px,*,50px" border="0">
	<frame id="banner" name="banner" src="banner.ps1" noresize="1" framespacing="0" frameborder="0" scrolling="no">
	<frameset cols="240px,*">
		<frame id="sidebar" name="sidebar" src="sidebar.ps1" noresize="1" framespacing="0" frameborder="0" scrolling="yes">
		<frame id="main" name="main" src="$mainPage" framespacing="0" frameborder="0" scrolling="yes">
	</frameset>
	<frame id="footer" name="footer" src="footer.ps1" noresize="1" scrolling="no" framespacing="0" frameborder="0" border="0">
</frameset>
</html>
"@