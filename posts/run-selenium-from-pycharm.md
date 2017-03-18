<!-- 
.. title: Run Selenium from PyCharm
.. slug: run-selenium-from-pycharm
.. date: 2016-11-16 18:00:41 UTC-06:00
.. tags: pytest, selenium, pycharm, python
.. category: 
.. link: 
.. previewimage: images/flowfx.jpg
.. description: 
.. type: text
-->

In order to run the Selenium WebDriver from within PyCharm, you need to explicitly add the path of the browser driver executable.

It is in fact _not_ necessary to add the [PyCharm Selenium plugin](http://www.seleniumhq.org/projects/webdriver/).

My PyTest fixture for the Selenium browser now looks like this:

    from selenium import webdriver
    import pytest
    
    @pytest.fixture(scope="session")
    def browser():
        browser = webdriver.PhantomJS(executable_path="/usr/local/bin/phantomjs",
                                      desired_capabilities={
                                      'phantomjs.page.settings.loadImages': 'false',
                                      })
        browser.implicitly_wait(3)
    
        yield browser
    
        browser.quit()

I'm using [PhantomJS](http://phantomjs.org/) as a headless browser because it is _way_ faster than Firefox or Chrome. I wish I could disable all loading of CSS files.


## Update 2017-01-18
Putting the explicit path to the browser driver executable into the test fixture causes problems when I run the same test on [Snap CI](https://snap-ci.com/). A better solution is to add the directory of the (PhantomJS) executable into PyCharm itself.

In my PyCharm Community Edition 2016.2 I go to <code>Run >> Edit Configurations…</code>, select the run configuration that runs my functional test and put

    PATH=/usr/local/bin/

into <code>Environment variabls</code>. That's all. Now PyCharm finds the executable of PhantomJS in that directory and I can remove the <code>executable_path</code> line from the fixture.

I do not know why PyCharm doesn't just import the $PATH from my shell.
