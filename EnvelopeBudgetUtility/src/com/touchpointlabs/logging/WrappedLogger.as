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
package com.touchpointlabs.logging
{
	import flash.events.Event;

	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.ObjectUtil;

	public class WrappedLogger implements Logger
	{
		public function WrappedLogger(logger : ILogger)
		{
			this.logger = logger;
		}

		public function prettyPrintObjectIfDebugEnabled(objectToPrint : Object, optionalMessage : String="") : void
		{
			var message : String = "{0}...\n{1}";
			if (isDebugEnabled)
			{
				debug(message, optionalMessage, ObjectUtil.toString(objectToPrint));
			}
		}

		public function get isDebugEnabled() : Boolean
		{
			return mx.logging.Log.isDebug();
		}

		public function get isErrorEnabled() : Boolean
		{
			return mx.logging.Log.isError();
		}

		public function get isFatalEnabled() : Boolean
		{
			return mx.logging.Log.isFatal();
		}

		public function get isInfoEnabled() : Boolean
		{
			return mx.logging.Log.isInfo();
		}

		public function get isWarningEnabled() : Boolean
		{
			return mx.logging.Log.isWarn();
		}

		public function get category() : String
		{
			return logger.category;
		}

		public function log(level : int, message : String, ... parameters) : void
		{
			logger.log(level, message, parameters);
		}

		public function debug(message : String, ... parameters) : void
		{
			logger.debug(message, parameters);
		}

		public function error(message : String, ... parameters) : void
		{
			logger.error(message, parameters);
		}

		public function fatal(message : String, ... parameters) : void
		{
			logger.fatal(message, parameters);
		}

		public function info(message : String, ... parameters) : void
		{
			logger.info(message, parameters);
		}

		public function warn(message : String, ... parameters) : void
		{
			logger.warn(message, parameters);
		}

		public function addEventListener(type : String, listener : Function, useCapture : Boolean=false, priority : int=0, useWeakReference : Boolean=false) : void
		{
			logger.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function removeEventListener(type : String, listener : Function, useCapture : Boolean=false) : void
		{
			logger.removeEventListener(type, listener, useCapture);
		}

		public function dispatchEvent(event : Event) : Boolean
		{
			return logger.dispatchEvent(event);
		}

		public function hasEventListener(type : String) : Boolean
		{
			return logger.hasEventListener(type);
		}

		public function willTrigger(type : String) : Boolean
		{
			return logger.willTrigger(type);
		}

		private var logger : ILogger;
	}
}
