<?php

declare(strict_types=1);

namespace App\Repositories;

class OrderItemRepository extends AbstractRepository
{
    const TABLE = 'order_item';

    public function getTableName(): string
    {
        return static::TABLE;
    }
}