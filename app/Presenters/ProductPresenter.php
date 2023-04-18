<?php

declare(strict_types=1);

namespace App\Presenters;

use App\Components\BuyProductComponent;
use App\Repositories\ProductRepository;
use Nette\Application\UI\Presenter;


final class ProductPresenter extends Presenter
{
    public function __construct(
        private readonly ProductRepository $productRepository,
    )
    {
    }

    public function renderDefault(string $productCoolUri): void
    {
        $product = $this->productRepository->findBy(['cool_uri' => $productCoolUri]);

        if (null === $product) {
            $this->error();
        }

        $this->template->product = $product;
    }

}
