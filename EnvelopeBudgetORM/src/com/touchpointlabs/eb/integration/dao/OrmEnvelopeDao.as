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
package com.touchpointlabs.eb.integration.dao
{
	import com.touchpointlabs.eb.domain.entity.Envelope;
	import com.touchpointlabs.eb.domain.entity.OrmEnvelope;
	import com.touchpointlabs.logging.LogFactory;

	import mx.collections.IList;

	import nz.co.codec.flexorm.IEntityManager;



	public class OrmEnvelopeDao extends OrmDao implements EnvelopeDao
	{

		public function OrmEnvelopeDao(entityManager : IEntityManager, defaultEnvelope : OrmEnvelope, logFactory : LogFactory)
		{
			super(entityManager, logFactory.getLogger(OrmEnvelopeDao));
			this.defaultEnvelope = defaultEnvelope;
			log.debug("The default envelope template is set to: {0}", defaultEnvelope.name);
			ensureAtLeastOneEnvelopeExists();
		}


		public function findAll(listToPopulate : IList) : void
		{
			listToPopulate.removeAll();
			var all : IList = entityManager.findAll(OrmEnvelope);
			log.debug("found {0} Envelopes", all.length);

			for (var index : int = 0; index < all.length; index++)
			{
				var envelope : Envelope = Envelope(all.getItemAt(index));
				listToPopulate.addItem(envelope);
			}
		}


		public function create(name : String) : Envelope
		{
			var envelope : OrmEnvelope = new OrmEnvelope();
			envelope.name = name;
			return createWithEnvelope(envelope);
		}


		private function ensureAtLeastOneEnvelopeExists() : void
		{
			var existingEnvelopes : IList = entityManager.findAll(OrmEnvelope);

			if (existingEnvelopes.length <= 0)
			{
				log.debug("creating a default envelope");
				createWithEnvelope(defaultEnvelope);
			}
		}


		private function createWithEnvelope(envelope : Envelope) : Envelope
		{
			log.prettyPrintObjectIfDebugEnabled(envelope, "creating an envelope");

			var id : int = entityManager.save(envelope);

			log.debug("ORM returned a new id of: {0}", id);

			var persistedEnvelope : Envelope = Envelope(entityManager.load(OrmEnvelope, id));

			log.prettyPrintObjectIfDebugEnabled(persistedEnvelope, "Loaded persisted Envelope");

			return persistedEnvelope;
		}

		private var defaultEnvelope : OrmEnvelope;

	}
}
