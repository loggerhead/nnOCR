#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import config
from predict import predict
from flask import Flask, request, redirect, url_for
from werkzeug import secure_filename
try:
    from flask_debugtoolbar import DebugToolbarExtension
except:
    pass


app = Flask(__name__)
app.debug = True
app.config['MAX_CONTENT_LENGTH'] = config.max_content_length * 1024 * 1024
app.config['UPLOAD_FOLDER'] = config.upload_folder
app.config['SECRET_KEY'] = 'test.'
app.config['DEBUG_TB_PANELS'] = (
   'flask_debugtoolbar.panels.headers.HeaderDebugPanel',
   'flask_debugtoolbar.panels.request_vars.RequestVarsDebugPanel',
)
try:
    toolbar = DebugToolbarExtension(app)
except:
    pass


ALLOWED_EXTENSIONS = set(config.allowed_extensions)

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def get_savepath(filename):
    return os.path.join(app.config['UPLOAD_FOLDER'], filename)

@app.route('/', defaults={'path': ''}, methods=['GET', 'POST'])
@app.route('/<path:path>', methods=['GET', 'POST'])
def index(path):
    if request.method == 'POST':
        for file in request.files.values():
            if file and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                filepath = get_savepath(filename)
                file.save(filepath)
                return """
                {
                    "filename": "%s",
                    "predict": "%s",
                }
                """ % (filename, predict(filepath))
    else:
        return """
        <!doctype html>
        <title>Upload new File</title>
        <body>
        <form action="/" method="post" enctype="multipart/form-data">
            <input type=file name=file>
            <input type=submit value=Upload>
        </form>
        <p>%s</p>
        </body>
        """ % "<br>".join(os.listdir(app.config['UPLOAD_FOLDER'],))


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
