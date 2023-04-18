<?php

declare(strict_types=1);

namespace App\Repositories;

class OrderRepository extends AbstractRepository
{
    const TABLE = 'order';

    public function getTableName(): string
    {
        return static::TABLE;
    }
}