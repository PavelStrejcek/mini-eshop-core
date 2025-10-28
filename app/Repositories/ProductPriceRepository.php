<?php

declare(strict_types=1);

namespace App\Repositories;

use Nette\Database\ResultSet;

class ProductPriceRepository extends AbstractRepository
{
    const TABLE = 'product_price';

    public function getTableName(): string
    {
        return static::TABLE;
    }

    public function updateAllEurPrices(string $rate): ResultSet
    {
        return $this->db->getConnection()->query('UPDATE product_price pp1 SET', [
            'amount' => $this->db::literal('pp2.amount / ?', $rate),
        ], "FROM product_price pp2 WHERE pp1.product_id = pp2.product_id AND pp1.currency = 'EUR' AND pp2.currency = 'CZK'");
    }
}