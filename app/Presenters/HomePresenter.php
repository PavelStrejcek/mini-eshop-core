<?php

declare(strict_types=1);

namespace App\Presenters;

use App\Components\BuyProductComponent;
use App\Components\CartInfoComponent;
use App\Repositories\ProductRepository;
use Nette\Application\UI\Presenter;


final class HomePresenter extends Presenter
{
    public function __construct(
        private readonly ProductRepository $productRepository,
    )
    {
    }

    public function renderDefault(int $page = 1): void
    {
        $products = $this->productRepository->findPublishedProducts();

        $lastPage = 0;
        $this->template->products = $products->page($page, 5, $lastPage);

        $this->template->page = $page;
        $this->template->lastPage = $lastPage;
    }

    protected function createComponentCartInfo(): CartInfoComponent
    {
        $cartInfo = new CartInfoComponent($this->getSession(), $this->productRepository);
        $cartInfo->redrawControl();
        return $cartInfo;
    }


}
