<?php

declare(strict_types=1);

namespace App\Forms;

use Nette\Application\UI\Form;

class OrderFormFactory
{
    public function create(): Form
    {
        $form = new Form;
        $form->addEmail('email', 'E-mail:')
            ->setRequired('Zadejte prosím e-mail');
        $form->addText('fullname', 'Jméno a příjmení:')
            ->addRule($form::Pattern, 'Zadejte prosím jméno a příjmení', '.{3,}')
            ->setRequired('Zadejte prosím jméno a příjmení');
        $form->addText('phone', 'Telefon:')
            ->addRule($form::Pattern, 'Zadejte prosím telefon', '[\d /*+-]{9,}')
            ->setRequired('Zadejte prosím telefon');
        $form->addSubmit('send', 'Vytvořit objednávku');

        return $form;
    }
}
