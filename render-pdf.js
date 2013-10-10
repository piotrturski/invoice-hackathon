var page = require('webpage').create(),
    system = require('system');

page.viewportSize = { width: 1600, height: 600 };
page.paperSize = { format: 'A4', orientation: 'portrait', margin: '1.5cm' };

page.open(system.args[1], function() {
    page.render('/dev/stdout', { format: 'pdf' });
    phantom.exit();
});
