<?php

namespace Tests\Models;
use App\Models\CnbRates;
use Tester\Assert;
use Tester\TestCase;

require __DIR__ . '/../bootstrap.php';
class CnbRatesTest extends TestCase
{
    public function testRetrieve()
    {
        $cnbRates = new CnbRates('https://www.cnb.cz/cs/financni_trhy/devizovy_trh/kurzy_devizoveho_trhu/denni_kurz.txt');
        $ratesContent = $cnbRates->retrieve();
        Assert::type('string', $ratesContent);
        Assert::match('~EUR\|([\d\,]+)~', $ratesContent);
    }
}

(new CnbRatesTest)->run();
