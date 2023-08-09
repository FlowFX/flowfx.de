---
title: "Testing Bootstrap select dropdown field with Selenium (Python)"
slug: testing-bootstrap-select-dropdown-field-with-selenium-python
date: 2016-10-17
taxonomies:
  tags: ["python", " flask", " selenium", " bootstrap"]
  categories: ["tech"]
---


I am building a [Flask](http://flask.pocoo.org/) app that uses the [Bootstrap](https://getbootstrap.com/) CSS framework. Forms fields are generated with [WTForms](https://wtforms.readthedocs.io/en/latest/) via the [Flask-WTF](https://flask-wtf.readthedocs.io/en/stable/) extension.

One of my forms includes a select field:

    <div class="form-group ">
        <label class="control-label" for="surface">Surface</label>
        
        <select class="form-control" id="surface" name="surface">
            <option value="clay">Clay</option>
            <option value="hard">Hard</option>
            <option value="grass">Grass</option>
        </select>
    </div>


My functional tests with [Selenium](https://selenium-python.readthedocs.io/index.html) went fine until I changed the desired test value from the default ("Clay") to a different option ("Hard"). (duh!!) So I knew I did something wrong and looked for the correct way to choose an option from a select field.

All the tests use the Selenium WebDriver.

    from selenium import webdriver
    
    browser = webdriver.Firefox()

## How it doesn't work
Via Google and Stackoverflow I found several possible solutions, none of which worked for me. 
My favorite one uses the [Selenium Webdriver Select class](https://selenium-python.readthedocs.io/api.html#module-selenium.webdriver.support.select):

    from selenium.webdriver.support.ui import Select
    
    select = Select(browser.find_element_by_id('surface'))
    select.select_by_visible_text("Hard")
    select.click()


Then there are solutions using the <code>find_element_by_xpath</code> method:

    option = browser.find_element_by_xpath("//select[@id='surface']/option[@value='hard']")
    option.click()

or <code>find_element_by_css_selector</code>:

    option = browser.find_element_by_css_selector("select#surface > option[value='hard']")
    option.click()

and one other looking for the <code>option</code> fields:

    dropdown = browser.find_element_by_id('surface')
    for option in dropdown.find_elements_by_tag_name('option'):
        if option.text == 'Hard':
            option.click()
            break

Apparently, Bootstrap does not play with Selenium. Or whatever. 
## How it does works
I don't remember where I got the idea to my solution, but it's simple and obvious. It selects the dropdown menu, and then types in the text that I want to click. Then hits enter and voilá, the desired option is selected.

    from selenium.webdriver.common.keys import Keys
    
    dropdown = browser.find_element_by_id('surface')
    dropdown.send_keys('Hard')
    dropdown.send_keys(Keys.ENTER)    

If you have a better way to select an option in a Bootstrap select field with the Selenium WebDriver, then [please tell me](https://flowfx.de/contact/)! 