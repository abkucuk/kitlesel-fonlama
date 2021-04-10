<script>
import axios from "axios";

export default {
  name: "HelloWorld",
  props: {
    msg: String,
  },
  data() {
    return {
      filterValue: "",
      rowSize: "",
      autoWidth: false,
      sortable: false,
      title: "Countries",
      columns: ["Name", "Capital", "Region", "Flag"],
      jsonData: null,
      use_actions: true,
      use_batchActions: true,
    };
  },
  methods: {
    onFilter(val) {
      console.log(`onfilter methoduna gelen val : ${val}`);
      this.filterValue = val;
    },
    onSort(sortBy) {
      if (sortBy) {
        this.internalData.sort((a, b) => {
          const itemA = a[sortBy.index];
          const itemB = b[sortBy.index];

          if (sortBy.order === "descending") {
            if (sortBy.index === 2) {
              // sort as number
              return parseFloat(itemA) - parseFloat(itemB);
            } else {
              return itemB.localeCompare(itemA);
            }
          }
          if (sortBy.order === "ascending") {
            if (sortBy.index === 2) {
              // sort as number
              return parseFloat(itemB) - parseFloat(itemA);
            } else {
              return itemA.localeCompare(itemB);
            }
          }
          return 0;
        });
      }
    },
  },
  mounted() {
    axios.get("https://restcountries.eu/rest/v2/all").then(
      (response) =>
        (this.jsonData = response.data.map(
          ({ name, capital, region, flag }) => ({
            name,
            capital,
            region,
            flag,
          })
        ))
    );
  },
  watch: {},
  computed: {
    filteredData: function () {
      let newData;
      if (this.filterValue) {
        const regex = new RegExp(this.filterValue, "i");
        newData = this.jsonData.filter((item) => {
          return Object.values(item).filter((st) => {
            return st.search(regex) >= 0;
          }).length > 0
            ? true
            : false;
        });
      } else {
        newData = this.jsonData;
      }
      if (this.pageStart) {
        return newData.slice(this.pageStart, this.pageStart + this.pageLength);
      } else {
        return newData;
      }
    },
  },
};
</script>

<template>
  <div class="hello">
    <cv-data-table
      :sortable="sortable"
      :columns="columns"
      searchLabel="Filter"
      searchPlaceholder="Filter"
      searchClearLabel="Clear filter"
      
      @search="onFilter"
      @sort="onSort"
      ref="table"
    >
    <template slot="data">
       <cv-data-table-row
          v-for="(row, rowIndex) in filteredData"
          :key="`${rowIndex}`"
          :value="`${rowIndex}`"
        >
         <cv-data-table-cell>
            <p>{{row.name}}</p>
          </cv-data-table-cell>
          <cv-data-table-cell>
            <p>{{row.capital}}</p>
          </cv-data-table-cell>
          <cv-data-table-cell>
            <p>{{row.region}}</p>
          </cv-data-table-cell>
          <cv-data-table-cell>
            <img :src="row.flag" style="height: 50px; width:50px" />
          </cv-data-table-cell>
        </cv-data-table-row>
    </template>
    </cv-data-table>
   
  </div>
</template>



<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
