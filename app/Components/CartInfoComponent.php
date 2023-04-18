<?php

declare(strict_types=1);

namespace App\Components;

use App\Repositories\ProductRepository;
use Nette\Application\UI\Control;
use Nette\Http\Session;

class CartInfoComponent extends Control
{
    public function __construct(
        private Session           $session,
        private ProductRepository $productRepository
    )
    {
    }

    public function handleAddItem(string $itemId): void
    {
        $product = $this->productRepository->get(strtr($itemId, '_', '-'));

        if (null === $product) {
            return;
        }

        $section = $this->session->getSection('cart');
        foreach ($product->related('product_price') as $price) {
            if ('CZK' === $price->currency) {
                $section->totalPriceCzk += $price->amount;
            } elseif ('EUR' === $price->currency) {
                $section->totalPriceEur += $price->amount;
            }

        }

        $section->numberOfItems = $section->numberOfItems + 1;

        $section->products[$product->id] = ($section->products[$product->id] ?? 0) + 1;
    }

    public function render(): void
    {
        $section = $this->session->getSection('cart');
        $template = $this->template;
        $template->totalPriceCzk = $section->get('totalPriceCzk') ?? 0;
        $template->totalPriceEur = $section->get('totalPriceEur') ?? 0;
        $template->numberOfItems = $section->get('numberOfItems') ?? 0;
        $template->render(__DIR__ . '/templates/CartInfoControl.latte');
    }
}