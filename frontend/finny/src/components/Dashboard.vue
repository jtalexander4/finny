<template>
  <div id="app">
    <layout-golden class="screen">
      <gl-col :closable="false">
        <gl-row :closable="false">
          <gl-component title="compA">
            <h1>CompA</h1>
            tab: {{selected}}
            <button @click="bottomSheet = !bottomSheet">Toggle</button>
            <button @click="addStack">Add</button>
          </gl-component>
          <gl-stack ref="myStack">
            <gl-component v-for="stackSub in stackSubs" :key="stackSub" :title="'dynamic'+stackSub">
              Added item (id: {{stackSub}})
              <button @click="remStack(stackSub)">Remove</button>
            </gl-component>
          </gl-stack>
        </gl-row>
        <gl-stack v-model="selected">
          <gl-component title="compB" tab-id="b">
            <h1>CompB</h1>
            <button @click="selected = 'c'">Toggle</button>
          </gl-component>
          <gl-component title="compC" tab-id="c">
            <h1>CompC</h1>
            <button @click="selected = 'b'">Toggle</button>
          </gl-component>
        </gl-stack>
        <gl-component v-if="bottomSheet">
          <h1>Bottom</h1>
        </gl-component>
      </gl-col>
    </layout-golden>
  </div>
</template>
<script>
export default {
  name: 'app',
  data: function() {
    return {
      bottomSheet: false,
      selected: 'b',
      stackSubs: [1],
      ssId: 1,
    };
  },
  methods: {
    addStack() {
      //this.$refs.myStack.addGlChild(...)
      this.stackSubs.push(++this.ssId);
    },
    remStack(id) {
      var ndx = this.stackSubs.indexOf(id);
      if (~ndx) this.stackSubs.splice(ndx, 1);
    },
  },
};
</script>
<style>
body {
  overflow: hidden; /* The 'light' theme let a scroll-bar on the right of the main container */
}
.screen {
  width: 100vw;
  height: 100vh;
}
</style>
