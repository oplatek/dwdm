<?php
$maxAuthors = 200; // doesn't affect the amount of data generated
$authorDepartments = array('World News', 'U.S. News', 'Sports', 'Entertainment', 'Finance');
$authorExperience = array('Intern', 'Junior Reporter', 'Senior Reporter', 'Editor', 'Guest');
$authors = array();
for ($i = 1; $i <= $maxAuthors; $i++) {
	$dept = $authorDepartments[rand(0, count($authorDepartments)-1)];
	$exp = $authorExperience[rand(0, count($authorExperience)-1)];
	if ($exp == 'Guest') $dept = 'n/a';
	$authors[$i] = array('department' => $dept, 'experience' => $exp);
}

$categories = array(
	'World' => array('Africa', 'U.K.', 'Asia', 'Middle East', 'U.S.', 'China', 'Hong Kong', 'SE Asia', 'Russia', 'India', 'Japan', 'Canada', 'Latin America'),
	'Business' => array('Earnings', 'Economy', 'Health', 'Law', 'Autos', 'Management'),
	'Tech' => array('Digits', 'Personal Technology', 'What They Know', 'Video'),
	'Life & Style' => array('Fashion', 'Food & Wine', 'Travel', 'Property', 'Culture', 'Sports')
);

$tags = array(
	1 => array('positive', 'negative', 'neutral'),
	2 => array('short', 'medium', 'long')
);

echo "INSERT INTO artpop.Tag VALUES ";
foreach ($tags as $n => $t) {
	foreach ($t as $n2 => $tag) {
		$tagid = $n * 10 + $n2;
		echo "\n";
		echo "($tagid, '$tag')";
		echo end($t) == $tag && end ($tags) == $t ? ';' : ',';
	}
}
echo "\n\n";

$startDate = strtotime('-1 month'); // affects the amount of data generated, examples: -1 year, -10 years etc.
$endDate = time();

echo "INSERT INTO artpop.Date VALUES ";
for ($date = $startDate; $date <= $endDate; $date += 86400) {
	for ($h = 0; $h <= 23; $h++) {
		$day = date('d', $date);
		$month = date('m', $date);
		$year = date('Y', $date);
		$H = str_pad($h, 2, '0', STR_PAD_LEFT);
		$dateID = "$year$month$day$H";
		echo "\n";
		echo "($dateID, $h, $day, $month, $year)";
		echo $date + 86400 >= $endDate && $h == 23 ? ';' : ',';
	}
}
echo "\n\n";

// affects the amount of data generated
$maxArticlesPerDay = 150;
$minArticlesPerDay = 50;

// doesn't affect the amount of data generated
$maxReads = 20000;
$maxComments = 250;
$maxShares = 350;

$articleID = 1;
// every day we generate some articles
for ($date = $startDate; $date <= $endDate; $date += 86400) {
	// num of articles on this day
	$articlesOnThisDay = rand($minArticlesPerDay, $maxArticlesPerDay);
	for ($i = 0; $i < $articlesOnThisDay; $i++) {
		$categoryNum = rand(0, count($categories)-1);
		$category = reset(array_slice(array_keys($categories), $categoryNum, 1));
		$subcategory = rand(0, count($categories[$category])-1);
		$author = rand(0, $maxAuthors-1) + 1;
		$day = date('d', $date);
		$month = date('m', $date);
		$year = date('Y', $date);
		$articleID++;
		
		// save this article
		echo "INSERT INTO artpop.Article VALUES ($articleID, 'Article #$articleID', '{$categories[$category][$subcategory]}', '{$category}', 'Author #$author', '{$authors[$author]['experience']}', '{$authors[$author]['department']}', $day, $month, $year);\n";
		
		// add some random tags
		foreach ($tags as $n => $t) {
			if (rand() % 5 != 0) {
				$tagid = $n * 10 + rand(0, count($t)-1);
				echo "INSERT INTO artpop.ArticleTags VALUES ($tagid, $articleID);\n";
			}
		}
		
		// create some reads/comments/shared data
		// it's very popular on the 1st day, less popular on the 2nd date, after a year or so it gets very few reads and shares etc.
		echo "INSERT INTO artpop.ArticlePopularity VALUES ";
		for ($d = $date; $d <= $endDate; $d += 86400) {
			for ($h = 0; $h <= 23; $h++) {
				$dd = date('Ymd', $d) . str_pad($h, 2, '0', STR_PAD_LEFT);
				//$reads = round($maxReads * 1/(1+log10(($d-$date+86400)/86400)));
				$x = ($d-$date+86400)/86400;
				if ($x > 30 * 3)  { $reads = rand(0, $maxReads / 200); $comments = rand() % 20 == 0 ? rand(0, 3) : 0; $shares = rand() % 17 == 0 ? rand(0, 5) : 0;  }
				else if ($x > 30) { $reads = rand(0, $maxReads / 100); $comments = rand() % 10 == 0 ? rand(0, 3) : 0; $shares = rand() % 8 == 0 ? rand(0, 5) : 0;  }
				else if ($x > 7)  { $reads = rand(0, $maxReads / 20); $comments = rand() % 3 == 0 ? rand(0, 3) : 0; $shares = rand() % 3 == 0 ? rand(0, 5) : 0;  }
				else if ($x > 3)  { $reads = rand($maxReads / 2, $maxReads / 5); $comments = rand(0, 5); $shares = rand(0, 15);  }
				else if ($x > 1)  { $reads = rand($maxReads / 2, $maxReads / 5); $comments = rand(0, 30); $shares = rand(0, 80);  }
				else              { $reads = rand($maxReads / 2, $maxReads); $comments = rand(0, $maxComments); $shares = rand($maxShares/10, $maxShares);  }
				
				$reads = round($reads / 24); $comments = round($comments / 24); $shares = round($shares / 24);
				//echo "day $dd = $reads / $comments / $shares\n";
				echo "\n";
				echo "($dd, $articleID, $reads, $shares, $comments)";
				echo $d + 86400 >= $endDate && $h == 23 ? ';' : ',';
			}
		}
		//die;
	}
}
?>