<?php

declare(strict_types=1);

namespace App\Forms;

class OrderFormData
{
    public function __construct(
        public string $email,
        public string $fullname,
        public string $phone,
    )
    {
    }
}