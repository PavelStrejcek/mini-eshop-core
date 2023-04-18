<?php

declare(strict_types=1);

namespace App\Repositories;

use Nette\Database;
use Nette\Database\Row;
use Nette\Database\Table\ActiveRow;

abstract class AbstractRepository
{
    public function __construct(
        protected readonly Database\Explorer $db,
    )
    {
    }

    public function get(string $key): ?Database\Table\ActiveRow
    {
        return $this->getTable()->get($key);
    }

    protected function getTable(): Database\Table\Selection
    {
        return $this->db->table($this->getTableName());
    }

    abstract public function getTableName(): string;

    public function insert(iterable $data): Database\Table\ActiveRow|int|bool
    {
        return $this->db->table($this->getTableName())->insert($data);
    }

    public function findIn(array $ids): Database\Table\Selection
    {
        return $this->getTable()->where('id', $ids);
    }

    public function findBy(array $cols): ?ActiveRow
    {
        return $this->getTable()->where($cols)->fetch();
    }

    public function genRandomUuid(): string
    {
        /** @var Row $row */
        $row = $this->db->query('SELECT gen_random_uuid() as uuid')->fetch();
        return $row->uuid;
    }
}