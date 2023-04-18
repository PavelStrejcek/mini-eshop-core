<?php

declare(strict_types=1);

namespace App\Commands;

use App\Repositories\ExchangeRateRepository;
use App\Repositories\ProductPriceRepository;
use App\Models\CnbRatesInterface;
use Nette\Database\ResultSet;
use UnexpectedValueException;

readonly class ExchangeRateImport
{
    public function __construct(
        private ExchangeRateRepository $exchangeRateRepository,
        private ProductPriceRepository $productPriceRepository,
        private CnbRatesInterface      $cnbRates,
    )
    {
    }

    public function execute(): ResultSet
    {
        $ratesContent = $this->cnbRates->retrieve();
        if (!is_string($ratesContent) || !preg_match('~EUR\|([\d\,]+)~', $ratesContent, $matches)) {
            throw new UnexpectedValueException('Exchange rate could not be found.');
        }
        $rate = strtr($matches[1], ',', '.');
        $this->exchangeRateRepository->insert(['rate' => $rate, 'currency' => 'EUR']);
        return $this->productPriceRepository->updateAllEurPrices($rate);
    }
}