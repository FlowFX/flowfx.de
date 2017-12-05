<!--
.. title: Test-driven Python learning
.. slug: test-driven-python-learning
.. date: 2017-12-05 15:16:44 UTC-06:00
.. tags: python, testing
.. category: 
.. link: 
.. description: 
.. type: text
-->

Bugs are nice because I can learn from them. Recently I found a bug that taught me about floats in Python and how not to use them. I found it thanks to an automated test.

## The test
In a legal contract I had to print a monetary amount in a format similar to

`MXN $11,600.00 (eleven thousand, six hundred pesos 00/100 cents)`

My tests check the LaTeX source of the resulting PDF, looking for the correctly formatted string `11,600.00`, which represents an amount of `11,000` something plus a VAT of 16%, and also for the string `eleven thousand, six hundred`.

It essentially goes like this:

```python
from app.models import LeaseAgreement

def test_contract_states_rent_plus_vat():
    """Test correct statement of rent amount with and without IVA (VAT (USt (MWSt)))."""
        
    contract = LeaseAgreement.build(    
        rent_amount=Decimal(10000.00)
    )

    tex = contract.render_tex()
    
    assert '10,000.00' in tex
    assert '11,600.00' in tex
    assert 'eleven thousand, six hundred' in tex
```

The first two asserts did not fail, the third one did. My code actually printed

`MXN $11,600.00 (eleven thousand, five hundred and ninety-nine pesos 00/100 cents)`

## The bug
Turns out I had misused Python's `Decimal` class to calculate the amount plus VAT. Like this:

```python
>>> x = Decimal(10000) * Decimal(1.16)
```

Printing the number in the desired format works fine.

```python
>>> print('{:,.2f}'.format(x))
11,600.00
```

But rounding down for only printing the amount without decimal places does not.

```python
>>> num2words(int(x))
'eleven thousand, five hundred and ninety-nine'
```

That is because floats are not exact.

```
>>> Decimal(1.16)
Decimal('1.1599999999999999200639422269887290894985198974609375')
>>> int(Decimal(1.16)*10000)
11599
```

## The fix
Working with monetary amounts that round to 2 digits requires care. Thanks to [Rami](https://chaos.social/@rami) and others, I now know that I should have used e.g.

```
Decimal('1.16')
```

and

```
Decimal('1.16').quantize(Decimal('.01'), rounding=ROUND_HALF_UP)
```

when apropriate.