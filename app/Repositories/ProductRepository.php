<?php

declare(strict_types=1);

namespace App\Repositories;

use DateTime;
use Nette\Database\Table\Selection;

class ProductRepository extends AbstractRepository
{
    const TABLE = 'product';

    public function getTableName(): string
    {
        return static::TABLE;
    }

    public function findPublishedProducts(): Selection
    {
        return $this->getTable()
            ->where('created_at < ', new DateTime)
            ->order('created_at DESC');
    }
}