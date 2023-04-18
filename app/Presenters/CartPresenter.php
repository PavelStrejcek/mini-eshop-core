<?php

declare(strict_types=1);

namespace App\Presenters;

use App\Components\BuyProductComponent;
use App\Components\CartInfoComponent;
use App\Forms\OrderFormData;
use App\Forms\OrderFormFactory;
use App\Repositories\OrderItemRepository;
use App\Repositories\OrderRepository;
use App\Repositories\ProductRepository;
use Nette\Application\UI\Form;
use Nette\Application\UI\Presenter;


final class CartPresenter extends Presenter
{
    public function __construct(
        private readonly ProductRepository   $productRepository,
        private readonly OrderRepository     $orderRepository,
        private readonly OrderItemRepository $orderItemRepository,
        private readonly OrderFormFactory    $orderFormFactory,
    )
    {
    }

    public function renderDefault(int $page = 1): void
    {
        $section = $this->getSession()->getSection('cart');

        if (null === $section->products) {
            $this->setView('empty');
            return;
        }

        $section = $this->getSession()->getSection('cart');
        $products = $this->productRepository->findIn(array_keys($section->products));

        $this->template->products = $products;
        $this->template->cartSession = $section->products;
    }

    public function orderFormSucceeded(Form $form, OrderFormData $data): void
    {

        $section = $this->getSession()->getSection('cart');

        if (null === $section->products) {
            $this->setView('empty');
            return;
        }

        $orderUuid = $this->orderRepository->genRandomUuid();
        $this->orderRepository->insert([
            'id' => $orderUuid,
            'email' => $data->email,
            'fullname' => $data->fullname,
            'phone' => $data->phone,
            'total' => $section->totalPriceCzk,
        ]);

        foreach ($this->productRepository->findIn(array_keys($section->products)) as $product) {
            $price = [];
            foreach ($product->related('product_price') as $productPrice) {
                $price[$productPrice->currency] = $productPrice->amount;
            }
            $this->orderItemRepository->insert([
                'order_id' => $orderUuid,
                'product_id' => $product->id,
                'name' => $product->name,
                'price_czk' => $price['CZK'],
                'price_eur' => $price['EUR'],
                'quantity' => $section->products[$product->id],
            ]);
        }

        $section->remove();

        $this->flashMessage('Objednávka byla odeslána. Děkujeme! Zboží se již připravuje.');
        $this->redirect('Home:');

    }

    protected function createComponentCartInfo(): CartInfoComponent
    {
        $cartInfo = new CartInfoComponent($this->getSession(), $this->productRepository);
        $cartInfo->redrawControl();
        return $cartInfo;
    }

    protected function createComponentOrderForm(): Form
    {
        $form = $this->orderFormFactory->create();
        $form->onSuccess[] = [$this, 'orderFormSucceeded'];
        return $form;
    }

}
