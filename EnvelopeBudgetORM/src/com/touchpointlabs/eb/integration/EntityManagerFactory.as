/**
 Copyright © 2012 Daniel Harfleet. All Rights Reserved.

  Redistribution and use in source and binary forms, with or without modification, are
  permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this list
  of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright notice, this
  list of conditions and the following disclaimer in the documentation and/or other
  materials provided with the distribution.

  3. The name of the author may not be used to endorse or promote products derived from
  this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY The Copyright Holder "AS IS" AND ANY EXPRESS OR IMPLIED
  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
  AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
  IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package com.touchpointlabs.eb.integration
{
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;

	import flash.data.SQLConnection;
	import flash.filesystem.File;

	import mx.utils.ObjectUtil;

	import nz.co.codec.flexorm.EntityManager;



	public class EntityManagerFactory
	{

		public function EntityManagerFactory(databaseName : String, logFactory : LogFactory, databaseDirectory : File=null)
		{
			this.databaseName = databaseName;
			this.log = logFactory.getLogger(EntityManagerFactory);
			this.databaseDirectory = (databaseDirectory != null) ? databaseDirectory : File.applicationStorageDirectory;
			log.debug("Database directory set to {0}", this.databaseDirectory);
		}


		[Factory]
		public function lookup() : EntityManager
		{
			var entityManager : EntityManager = EntityManager.instance;
			entityManager.sqlConnection = createSQLConnection();
			return entityManager;
		}


		private function createSQLConnection() : SQLConnection
		{
			log.debug("creating SQLConnection");
			var connection : SQLConnection = new SQLConnection();
			connection.open(lookupDatabaseFile());

			if (log.isDebugEnabled)
			{
				log.debug("Connection: {0}", ObjectUtil.toString(connection));
			}

			return connection;
		}


		private function lookupDatabaseFile() : File
		{
			log.debug("Looking up database file...");
			var file : File = databaseDirectory.resolvePath(databaseName);
			if (log.isInfoEnabled)
			{
				log.info("Database file name is: {0}", file.nativePath);
			}
			return file;
		}

		private var databaseName : String;
		private var databaseDirectory : File;
		private var log : Logger;
	}
}
