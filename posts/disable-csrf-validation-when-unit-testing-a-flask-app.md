<!-- 
.. title: Disable CSRF validation when unit-testing a Flask app!
.. slug: disable-csrf-validation-when-unit-testing-a-flask-app
.. date: 2016-11-14 16:45:58 UTC-06:00
.. tags: python, testing, flask, csrf
.. category:
.. link: 
.. description: Why you need to disable CSRF checks when unit-testing a Flask app.
.. type: text
-->

In my current Flask project, I wanted to test a view method that includes a form with a POST request. But it wouldn't work. 

The view method looks something like this:

    # views.py
    @tennis.route('/tournaments/add', methods=['GET', 'POST'])
    def add_tournament():
        form = AddTournamentForm()
        
        if form.validate_on_submit():
            t = Tournament(name=form.name.data)
            db.session.add(t)
            db.session.commit()
            
            flash('A tournament was added to the database.')
            return redirect(url_for('tennis.index'))

        return render_template('tennis/add_tournament.html',
                           form=form)
      
   
[Flask-Testing](https://pythonhosted.org/Flask-Testing/) provides a <code>TestCase</code> class with several useful assert methods. So the test would look like this:

    # test_views.py  
    from flask_testing import TestCase
    
    class TestTennisViews(TestCase):    
        […]   
          
        def test_tennis_add_tournament(self):
            # WHEN submitting correct form data to the add_tournament view
            r = self.client.post('/tennis/tournaments/add',
                                 data=dict(
                                     name='Chicharito Open',
                                 ))
        
            # THEN it redirects to the tennis overview page
            self.assertRedirects(r,'/tennis/')
            # and it shows a message
            self.assertMessageFlashed('A tournament was added to the database.')
            # and there is a tournament in the database
            assert Tournament.query.count() > 0
            # and it has the correct tournament
            t = Tournament.query.first()
            assert t.name == 'Chicharito Open'

**<code>assertRedirects</code>** checks if the status code is <code>301</code> or <code>302</code>. In my tests, it was always <code>200</code>, and the test failed. Of course, nothing was added to the database, either.

I googled _a lot_, without success. I tried all combinations of the following keywords, among others:

    flask
    unit test
    wtforms
    POST request
    testing

The solution hit me when taking a break (it works!). It lies in the <code>form.validate_on_submit()</code> part of the view function. <code>validate_on_submit()</code> does two things:

1. It validates the form fields according to the validators specified in the form definition.
2. It validates a [CSRF token](https://flask-wtf.readthedocs.io/en/stable/csrf.html).

Guess what: there is no CSRF token generated when executing a POST request directly in the test.

The solution is easy, as <code>FLASK-WTF</code> provides a [configuration option to disable CSRF](https://flask-wtf.readthedocs.io/en/stable/config.html#forms-and-csrf):

    # config.py
    
    […]
    
    class TestingConfig(Config):
        TESTING = True
        WTF_CSRF_ENABLED = False
        
        […]
        
    class FunctionalTestingConfig(TestingConfig)
        WTF_CSRF_ENABLED = False

Of course, only disable CSRF in your test configuration! I created a separate configuration for my functional tests, so that CSRF is enabled in those. When using the browser with Selenium, the CSRF token is provided by the WTForms form on the web page.
