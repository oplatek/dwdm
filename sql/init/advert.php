/* disables interactive pasting off values by '&' charector so I can insert values with '&' character */
set define off;
<?php
$maxAdvertisers = 500; // the higher this number, the more data it generates

// these dates don't affect the number of data generated
$minDate = strtotime('-5 years');
$maxDate = strtotime('-2 months');

$dates = array();

for ($a = 1; $a <= $maxAdvertisers; $a++) { // advertisers
	$maxCampaigns = rand(1, 100);
	
	// category could be anything, but here we just calculate it
	// let's categorize advertisers by how many campaigns they've ordered
	if ($maxCampaigns > 95) $advertiserCat = 'Top Client';
	else if ($maxCampaigns > 60) $advertiserCat = 'Big Fish';
	else if ($maxCampaigns > 20) $advertiserCat = 'Medium Fish';
	else $advertiserCat = 'Small Fish';
	
	$uniq = array();
	// each advertiser makes a number of campaigns
	for ($c = 1; $c <= $maxCampaigns; $c++) {
		$id = $a * 100000 + $c; // unique id for <advertiser, campaign>
		echo "INSERT INTO advert.Campaign VALUES ($id, 'Campaign #$c for Advertiser #$a', 'Advertiser #$a', '$advertiserCat');\n";
		
		// each campaign (= ad) is displayed for $days days starting on $startDate
		// we track how many times the ad was displayed, how many times it was clicked on and how much money we get from that
		$startDate = strtotime(date('Y-m-d', rand($minDate, $maxDate)));
		$days = rand(1, 30);
		for ($date = $startDate; $date < $startDate + 86400*$days; $date += 86400) {
			$d = date('Ymd', $date);
			$displays = rand(1, 50000);
			$clicks = rand(1, $displays/100);
			$revenue = $clicks * 0.03; // could be variable, taking into accounts discounts, negotiated price etc., but here we just calculate it
			
			// dates must be unique
			if (!isset($dates[$d])) {
				$day = date('d', $date);
				$month = date('m', $date);
				$year = date('Y', $date);
				$q = (int)floor($month / 3.1) + 1;
				echo "INSERT INTO advert.Date VALUES ($d, $day, $month, $q, $year);\n";
			}
			$dates[$d] = true;
			
			// make sure there's no duplicates by accident
			if (isset($uniq[$d.$id])) continue;
			$uniq[$d.$id] = true;
			
			echo "INSERT INTO advert.Advertisement VALUES ('$d', $id, $revenue, $displays, $clicks);\n";
		}
	}
}
