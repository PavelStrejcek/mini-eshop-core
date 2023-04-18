<?php

declare(strict_types=1);

namespace App\Models;

class CnbRates implements CnbRatesInterface
{
    public function __construct(
        private string $ratesUrl,
    )
    {
    }

    public function retrieve(): string|false
    {
        return file_get_contents($this->ratesUrl);
    }
}