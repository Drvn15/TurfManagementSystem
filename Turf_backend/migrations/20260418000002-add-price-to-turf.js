'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    const table = await queryInterface.describeTable('Turf');

    if (!table.price_per_hour) {
      await queryInterface.addColumn('Turf', 'price_per_hour', {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 0,
      });
    }
  },

  async down(queryInterface, Sequelize) {
    const table = await queryInterface.describeTable('Turf');

    if (table.price_per_hour) {
      await queryInterface.removeColumn('Turf', 'price_per_hour');
    }
  },
};
