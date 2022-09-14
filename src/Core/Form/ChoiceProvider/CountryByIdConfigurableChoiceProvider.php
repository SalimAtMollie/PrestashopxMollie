<?php
/**
 * 2007-2019 PrestaShop and Contributors
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Open Software License (OSL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * https://opensource.org/licenses/OSL-3.0
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to https://www.prestashop.com for more information.
 *
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2019 PrestaShop SA and Contributors
 * @license   https://opensource.org/licenses/OSL-3.0 Open Software License (OSL 3.0)
 * International Registered Trademark & Property of PrestaShop SA
 */

declare(strict_types=1);

namespace PrestaShop\PrestaShop\Core\Form\ChoiceProvider;

use PrestaShop\PrestaShop\Adapter\Country\CountryDataProvider;
use PrestaShop\PrestaShop\Core\Form\ConfigurableFormChoiceProviderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

/**
 * Class provides configurable country choices with ID values.
 */
final class CountryByIdConfigurableChoiceProvider implements ConfigurableFormChoiceProviderInterface
{
    /**
     * @var CountryDataProvider
     */
    private $countryDataProvider;

    /**
     * @var int
     */
    private $langId;

    /**
     * @param int $langId
     * @param CountryDataProvider $countryDataProvider
     */
    public function __construct(
        int $langId,
        CountryDataProvider $countryDataProvider
    ) {
        $this->langId = $langId;
        $this->countryDataProvider = $countryDataProvider;
    }

    /**
     * Get country choices.
     *
     * {@inheritdoc}
     */
    public function getChoices(array $options): array
    {
        $options = $this->resolveOptions($options);

        $countries = $this->countryDataProvider->getCountries(
            $this->langId,
            $options['active'],
            $options['contains_states'],
            $options['list_states']
        );

        $choices = [];
        foreach ($countries as $country) {
            $choices[$country['name']] = (int) $country['id_country'];
        }

        return $choices;
    }

    private function resolveOptions(array $options): array
    {
        $resolver = new OptionsResolver();
        $resolver->setDefaults([
            'active' => false,
            'contains_states' => false,
            'list_states' => false,
        ]);
        $resolver->setAllowedTypes('active', 'bool');
        $resolver->setAllowedTypes('contains_states', 'bool');
        $resolver->setAllowedTypes('list_states', 'bool');

        return $resolver->resolve($options);
    }
}
