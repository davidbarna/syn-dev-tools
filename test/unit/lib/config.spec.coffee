describe 'Config', ->

  Config = require( 'src/lib/config' )

  beforeEach ->
    @sinon = sinon.sandbox.create()
    @config =
      production:
        node1:
          node1prop1: 'node1prop1'
          node1prop2: 'node1prop2'
        node2:
          arrayNode: [ 'node1', 'node2' ]
          node2prop1: 'node2prop1'
          subnode2:
            node2prop1: 'node2prop1'
            node2prop2: 'node2prop2'
      development:
        _extends: 'production'
        node1:
          node1prop2: 'dev_node1prop2'
        node2:
          arrayNode: [ 'node3' ]
          subnode2:
            node2prop1: 'dev_node2prop1'
            newnode: 'dev_newnode'
      development2:
        _extends: 'development'
        node1:
          node1prop2: 'dev2_node1prop2'
    @instance = new Config()

  afterEach ->
    @sinon.restore()

  describe '#constructor', ->

    beforeEach ->
      @sinon.stub( Config.prototype, 'set' )
      @instance = new Config( 'fake-config', 'fake-env' )

    it 'should call @set function', ->
      Config::set.should.have.been.calledOnce
      Config::set.args[0][0].should.equal( 'fake-config' )
      Config::set.args[0][1].should.equal( 'fake-env' )

  describe '#set', ->

    describe 'when environment is defined', ->

      describe 'when environment is not extended', ->

        beforeEach ->
          @instance.set( @config, 'production' )

        it 'should maintain choosen properties' , ->
          @instance.node1.node1prop1.should.equal( 'node1prop1' )
          @instance.node1.node1prop2.should.equal( 'node1prop2' )

      describe 'when environment is extended once', ->

        beforeEach ->
          @instance.set( @config, 'development' )

        it 'should maintain not overwritten properties' , ->
          @instance.node1.node1prop1.should.equal( 'node1prop1' )
          @instance.node2.subnode2.node2prop2.should.equal( 'node2prop2' )

        it 'should merge existing properties' , ->
          @instance.node1.node1prop2.should.equal( 'dev_node1prop2' )
          @instance.node2.subnode2.node2prop1.should.equal( 'dev_node2prop1' )

        it 'should set new properties if found' , ->
          @instance.node2.subnode2.newnode.should.exist
          @instance.node2.subnode2.newnode.should.equal( 'dev_newnode' )

        it 'should set env property' , ->
          @instance.env.should.equal( 'development' )

      describe 'when environment is extended more than once', ->

        beforeEach ->
          @instance.set( @config, 'development2' )

        it 'should maintain not overwritten properties' , ->
          @instance.node1.node1prop1.should.equal( 'node1prop1' )
          @instance.node2.subnode2.node2prop2.should.equal( 'node2prop2' )

        it 'should merge existing properties' , ->
          @instance.node2.subnode2.node2prop1.should.equal( 'dev_node2prop1' )
          @instance.node1.node1prop2.should.equal( 'dev2_node1prop2' )

        it 'should not merge arrays' , ->
          @instance.node2.arrayNode.should.deep.equal [ 'node3' ]

      describe 'when environment is not defined or not found in config', ->

        it 'should throw an error', ->
          ( => @instance.set( @config ) ).should.throw

  describe '#clear', ->

    beforeEach ->
      @instance.set( @config, 'development2' )
      @instance.clear()

    it 'should unset all properties', ->
      expect( @instance.node1 ).to.be.undefined
      expect( @instance.node2 ).to.be.undefined

  describe '#toObject', ->

    beforeEach ->
      @instance.set( @config, 'development' )
      @obj = @instance.toObject()

    it 'should unset all properties', ->
      expect( @obj.node1 ).not.to.be.undefined
      expect( @obj.node2 ).not.to.be.undefined
      @obj.node2.subnode2.node2prop1.should.equal( 'dev_node2prop1' )
