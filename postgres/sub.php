INSERT INTO sub.Period VALUES
(1, 'Day'),
(2, 'Week'),
(3, 'Month'),
(4, 'Quarter'),
(5, 'Year');

<?php
// each location has rand(1, 5000) subscriptions
// the higher this number, the more data it generates
$maxLocations = 100; 

// these dates don't affect the amount of data generated
$minDate = strtotime('-10 years');
$maxDate = time();

$dates = array();

$locationID = 1;
foreach (array(/* 'us' => 'United States', */ 'canada' => 'Canada') as $filename => $country) {
	$fp = fopen('sub.' . $filename . '.csv', 'r');
	$firstLine = true;
	while (!feof($fp)) {
		$line = fgets($fp);
		if ($firstLine) { $firstLine = false; continue; }
		$parts = explode(',', trim($line));
		$city = str_replace(array('"', "'"), '', $parts[4]);
		$state = str_replace(array('"', "'"), '', $parts[5]);
		$zone = 'US & Canada';
		$continent = 'North America';
		
		echo "INSERT INTO sub.Location VALUES ($locationID, '$city', '$state', '$country', '$zone', '$continent');\n";
		echo "\n";
		
		// number of subscriptions in this city
		// this greatly affects the amount of data generated
		$subs = rand(1, 1000);
		
		// generate some random dates
		$ds = array();
		for ($i = 0; $i < $subs; $i++) {
			$d = rand($minDate, $maxDate); 
			$d = strtotime(date('Y-m-d', $d));
			if (in_array($d, $ds)) { $i--; continue; }
			$ds[$i] = $d;
		}
		
		// INSERT dates that we haven't seen before
		foreach ($ds as $date) {
			if (!isset($dates[$date])) {
				$key = date('Ymd', $date);
				$day = date('d', $date);
				$month = date('m', $date);
				$year = date('Y', $date);
				$week = date('W', $date);
				$christmas = date('md') == '2412' ? 'TRUE' : 'FALSE';
				$halloween = date('md') == '3110' ? 'TRUE' : 'FALSE';
				$easter = date('md') == '0804' ? 'TRUE' : 'FALSE'; // hack
				$thanksgiving = date('md') == '2411' ? 'TRUE' : 'FALSE'; // hack
				echo "INSERT INTO sub.Date VALUES ($key, $day, $month, $year, $week, $thanksgiving, $halloween, $easter, $christmas);\n";
			}
			$dates[$date] = true;
		}
		
		// generate subscriptions in this city
		for ($i = 0; $i < $subs; $i++) {
			$d = $ds[$i];
			$date = date('Ymd', $d);
			$period = rand(1, 5);
			$quantity = (rand() % 2 == 0 ? 1 : (rand() % 5 == 0 ? 2 : rand() % 10 == 0 ? 10 : 1));
			switch ($period) {
				case 1: $price = '1.99'; $discount = '0.00'; break;
				case 2: $price = '5.99'; $discount = rand() % 10 == 0 ? '0.025' : '0.00'; break;
				case 3: $price = '15.99'; $discount = rand() % 10 == 0 ? '0.05' : '0.00'; break;
				case 4: $price = '49.99'; $discount = rand() % 10 == 0 ? '0.085' : '0.00'; break;
				case 5: $price = '139.99'; $discount = rand() % 10 == 0 ? '0.10' : '0.00'; break;
			}
			echo "INSERT INTO sub.Subscription VALUES ($date, $locationID, $period, $quantity, $price, '$discount');\n";
		}
		
		echo "\n";
		
		$locationID++;
		
		if ($locationID > $maxLocations) break;
	}
	fclose($fp);
	if ($locationID > $maxLocations) break;
}