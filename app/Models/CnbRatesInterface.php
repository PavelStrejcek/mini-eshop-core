<?php

declare(strict_types=1);

namespace App\Models;

interface CnbRatesInterface
{
    public function retrieve(): string|false;
}