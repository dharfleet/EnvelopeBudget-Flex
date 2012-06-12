FlexOrm is a project hosted here:

http://flexorm.riaforge.org/

The project home page claims BSD license, however, none of the repository files contain license information and hence license information has not been added to any files.
Please consider all source code under the nz.co.codec.flexorm package to be accredited to the FlexOrm team and come under the terms of the license information specified at flexorm.riaforge.org.


The source code in this project has been adapted to allow specification of Interfaces within ManyToOne relationships, by adding the 'type' parameter:

Example:

[ManyToOne(cascade = "save-update", type = "com.touchpointlabs.eb.domain.entity.OrmEnvelope")]
		public function set envelope(value : Envelope) : void
		
where the type is the concrete implementation of the Interface.

The code changes can be found around line 448 of EntityIntrospector ONLY.

Note I would have liked to have sub-classed EntityIntrospector, however this proved time consuming due to the 'private' nature of the original class, hence I made a code change.

My intention at a later date would be to make/propose a more formal change, however, at this stage an 'experimental' change has been made to a clone of the code.

