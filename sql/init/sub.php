/* disables interactive pasting off values by '&' charector so I can insert values with '&' character */
set define off;

delete from sub_subscription;
delete from sub_date;
delete from sub_period;
delete from sub_location;

INSERT INTO sub_Period VALUES (1, 'Day', 1);
INSERT INTO sub_Period VALUES (2, 'Week', 2);
INSERT INTO sub_Period VALUES (3, 'Month', 3);
INSERT INTO sub_Period VALUES (4, 'Quarter', 4);
INSERT INTO sub_Period VALUES (5, 'Year', 5);

<?php
// each location (= city) has rand(1, 5000) subscriptions
// the higher this number, the more data it generates
$maxLocations = 20000;
// number of subscriptions in this city
// this greatly affects the amount of data generated
$subPerCity = 5000;

// these dates don't affect the amount of data generated
$minDate = strtotime('-10 years');
$maxDate = time();

$countries = array(
	array('United States', 'US & Canada', 'North America'),
	array('Canada', 'US & Canada', 'North America'),
	array('Italy', 'Western Europe', 'Europe'),
	array('France', 'Western Europe', 'Europe'),
	array('Spain', 'Western Europe', 'Europe'),
	array('Germany', 'Western Europe', 'Europe'),
	array('United Kingdom', 'Western Europe', 'Europe'),
	array('Ireland', 'Western Europe', 'Europe'),
	array('Poland', 'Eastern Europe', 'Europe'),
	array('Latvia', 'Eastern Europe', 'Europe'),
	array('Lithuania', 'Eastern Europe', 'Europe'),
	array('Estonia', 'Eastern Europe', 'Europe'),
	array('Sweden', 'Northern Europe', 'Europe'),
	array('Norway', 'Northern Europe', 'Europe'),
	array('Finland', 'Northern Europe', 'Europe'),
	array('Russia', 'Slavic Countries', 'Europe'),
	array('Belarus', 'Slavic Countries', 'Europe'),
	array('Ukraine', 'Slavic Countries', 'Europe'),
	array('China', 'Asia', 'Europe'),
	array('India', 'Asia', 'Europe')
);

// INSERT dates
for ($i = $minDate; $i < $maxDate; $i += 86400) {
	$date = $i;
	$key = date('Ymd', $date);
	$day = date('d', $date);
	$month = date('m', $date);
	$year = date('Y', $date);
	$week = date('W', $date);
	$dow = date('w', $date); if ($dow == 0) $dow = 7;
	$christmas = date('md',$date) == '2412' ? 'Y' : 'N';
	$halloween = date('md',$date) == '3110' ? 'Y' : 'N';
	$easter = date('md',$date) == '0804' ? 'Y' : 'N'; // hack
	$thanksgiving = date('md',$date) == '2411' ? 'Y' : 'N'; // hack
	echo "INSERT INTO sub_Date VALUES ($key, $day, $month, $year, $week, $dow, '$thanksgiving', '$halloween', '$easter', '$christmas');\n";
}

$stderr = fopen('php://stderr', 'w');

for ($subid = 1, $locationID = 1; $locationID < $maxLocations; $locationID++) {
        $c = $countries[mt_rand(0, count($countries)-1)];
        $country = $c[0];
        $city = "City #$locationID";
        $state = chr(mt_rand(65, 90)) . chr(mt_rand(65, 90));
        $zone = $c[1];
        $continent = $c[2];

        echo "INSERT INTO sub_Location VALUES ($locationID, '$city', '$state', '$country', '$zone', '$continent');\n";
        echo "\n";

        // number of subscriptions in this city
        $subs = mt_rand(0, $subPerCity);
        fputs($stderr, "$subs, $locationID/$maxLocations\n");

        // generate subscriptions in this city
        for ($i = 0; $i < $subs; $i++) {
			$date = mt_rand($minDate, $maxDate);
			$date = date('Ymd', $date);
			$period = mt_rand(1, 5);
			$quantity = (mt_rand() % 2 == 0 ? 1 : (mt_rand() % 5 == 0 ? 2 : mt_rand() % 10 == 0 ? 10 : 1));
			switch ($period) {
				case 1: $price = '1.99'; $discount = '0.00'; break;
				case 2: $price = '5.99'; $discount = mt_rand() % 10 == 0 ? '0.025' : '0.00'; break;
				case 3: $price = '15.99'; $discount = mt_rand() % 10 == 0 ? '0.05' : '0.00'; break;
				case 4: $price = '49.99'; $discount = mt_rand() % 10 == 0 ? '0.085' : '0.00'; break;
				case 5: $price = '139.99'; $discount = mt_rand() % 10 == 0 ? '0.10' : '0.00'; break;
			}
			echo "INSERT INTO sub_Subscription VALUES ($subid, $date, $locationID, $period, $quantity, $price, '$discount');\n";
			$subid++;
        }

        echo "\n";
}
