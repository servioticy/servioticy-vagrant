from __future__ import with_statement
from sqlite3 import dbapi2 as sqlite3
from hashlib import md5
from flask import Flask, request, session, g, redirect, url_for, \
    abort, render_template, flash, _app_ctx_stack, jsonify, Response
from werkzeug import check_password_hash, generate_password_hash
import uuid
import base64
import sys

# configuration
DATABASE = './users.db'
#DEBUG = True

# create the application
app = Flask(__name__)
app.config.from_object(__name__)
app.config.from_envvar('COMPOTHNGS_SETTINGS', silent=True);

# init a black db
def init_db():
  """Creates the database tables."""
  with app.app_context():
    db = get_db()
    with app.open_resource('schema.sql') as f:
      db.cursor().executescript(f.read())
    db.commit()

# connect to the db
def get_db():
  """Opens a new database connection if there is none yet for the
  current application context.
  """
  top = _app_ctx_stack.top
  if not hasattr(top, 'sqlite_db'):
    top.sqlite_db = sqlite3.connect(app.config['DATABASE'])
    top.sqlite_db.row_factory = sqlite3.Row
  return top.sqlite_db

# query the database
def query_db(query, args=(), one=False):
  """Queries the database and returns a list of dictionaries."""
  cur = get_db().execute(query, args)
  rv = cur.fetchall()
  return (rv[0] if rv else None) if one else rv

# query the database
def query_all(query, args=(), one=False):
  """Queries the database and returns a list of dictionaries."""
  cur = get_db().execute(query, args)
  resp='{ users: \n  [\n'
  for row in get_db().execute(query,args):
	resp+='\t{\n\t\tuser:"'+row['username']+'",'
        resp+='\n\t\ttoken:"'+row['api_token']+'"\n\t},\n'
  resp+='  ]\n}'
  return resp

def make_plain_response(response, code):
  response.status_code = (code)
  return response

# JSON response
def make_json_response(msg, code):
  response = jsonify(message=msg)
  response.status_code = (code)
  return response

# before request
@app.before_request
def before_request():
  g.user = None
  if 'user_id' in session:
    g.user = query_db('select * from user where user_id = ?',
        [session['user_id']], one=True)

# close the db connection in the teardown
@app.teardown_appcontext
def close_database(exception):
  """Closes the database again at the end of the request."""
  top = _app_ctx_stack.top
  if hasattr(top, 'sqlite_db'):
    top.sqlite_db.close()

@app.route('/resetDB', methods=['POST'])
def resetDB():
  """resetDB"""
  if request.method == 'POST':
    init_db()
    return make_json_response('DB INITIALITATED', 200)
  return make_json_response('POST method only', 400)

@app.route('/getToken/<username>', methods=['GET'])
def servioticyGetUser(username):
  user = query_db('select * from user where username= ?', [username], one=True)
  if user is None:
    return make_json_response('Invalid username', 400)

  return make_json_response(user['api_token'], 200)

@app.route('/getAllTokens', methods=['GET'])
def servioticyGetAllUsers():
  user = query_all('select * from user', one=True)
  if user is None:
    return make_json_response('Empty user database', 400)

  return make_plain_response(Response(user,  mimetype='application/json'), 200)

@app.route('/registerUser/<username>', methods=['POST'])
def servioticyCreateUser(username):
  user = query_db('select * from user where username = ?', [username], one=True)
  if user is not None:
    return make_json_response('Someone already has that username', 400)

  db = get_db()
  user_uuid = str(uuid.uuid4()).replace("-", "")
  user_token = base64.b64encode(str(uuid.uuid4())) + base64.b64encode(str(uuid.uuid4()))
  db.execute('''insert into user(username, uuid, api_token)
              values(?, ?, ?)''', [username, user_uuid, user_token])
  db.commit()
  return make_json_response(user_token, 201)



if __name__ == '__main__':
  app.run(host='0.0.0.0',port=5010)

